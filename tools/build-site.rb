# GitHub Pages 用の静的サイトを組み立てる。
#
# 各段階の README を HTML に変換し、tj3 が生成したレポートと tjp/tji のソースを
# 同じページに並べて「ブラウザだけで学習が完結する」形にする。
#
# サブコマンド:
#
#   ruby tools/build-site.rb stages
#     段階ディレクトリの一覧を JSON 配列で出力する (Actions の matrix 用)
#
#   ruby tools/build-site.rb entrypoint <段階ディレクトリ>
#     その段階を tj3 に渡すときのファイルパスを出力する
#
#   ruby tools/build-site.rb stage <段階ディレクトリ> [--output site]
#     <出力先>/<段階>/ を生成する。事前に tj3 を実行しておくこと
#
#   ruby tools/build-site.rb index [--output site]
#     <出力先>/index.html と共通 CSS を生成する
#
# 段階ページと index は独立に生成できる。Actions では stage を段階ごとに
# 並列実行し、最後に index と合わせて 1 つのサイトにまとめている。

require "cgi"
require "fileutils"
require "json"

ROOT = File.expand_path("..", __dir__)

# tj3 の出力に含まれる共通アセット。レポート一覧には出さない
ASSET_DIRS = %w[css icons scripts].freeze

# 段階ディレクトリの命名規則。README の学習ロードマップと同じ順序になる
STAGE_PATTERN = /\A\d\d-/

def stage_dirs
  Dir.children(ROOT)
     .select { |name| name.match?(STAGE_PATTERN) && File.directory?(File.join(ROOT, name)) }
     .sort
end

# tj3 に渡すファイル。11-modular のように .tji へ分割している段階は
# main.tjp だけが単体で実行できるため、あれば優先する
def entrypoint(stage)
  main = File.join(ROOT, stage, "main.tjp")
  return "#{stage}/main.tjp" if File.exist?(main)

  tjps = Dir.glob(File.join(ROOT, stage, "*.tjp")).sort
  case tjps.size
  when 1 then "#{stage}/#{File.basename(tjps.first)}"
  when 0 then abort "#{stage}: .tjp が無い"
  else abort "#{stage}: .tjp が複数ある。エントリポイントを main.tjp にすること (#{tjps.map { File.basename(_1) }.join(', ')})"
  end
end

# --- Markdown ---------------------------------------------------------------

# README 同士のリンクをサイトのパスに読み替える。
# ../README.md → ../ 、../02-structure/README.md → ../02-structure/
def rewrite_href(href)
  return href if href.start_with?("#") || href.match?(%r{\A[a-z][a-z0-9+.\-]*:}i)

  path, fragment = href.split("#", 2)
  return href unless path&.end_with?(".md")

  path = path.sub(/README\.md\z/, "").sub(/\.md\z/, "/")
  fragment ? "#{path}##{fragment}" : path
end

def rewrite_links!(element)
  element.attr["href"] = rewrite_href(element.attr["href"]) if element.type == :a && element.attr["href"]
  element.children.each { |child| rewrite_links!(child) }
end

def markdown_to_html(path)
  require "kramdown"
  require "kramdown-parser-gfm"

  # kramdown 本体のパーサは ``` を解釈しないため GFM パーサを使う。
  # <details> の中の Markdown を変換したい箇所には README 側で markdown="1" を付ける
  doc = Kramdown::Document.new(File.read(path), input: "GFM")
  rewrite_links!(doc.root)
  doc.to_html
end

# 段階 README は末尾を「--- 」+ 前後リンクで締めている。
# ページではレポートとソースを本文の続きに置くため、この部分だけ最下部へ回す
def split_nav(html)
  body, separator, nav = html.rpartition(%r{<hr\s*/?>})
  separator.empty? ? [html, ""] : [body, nav]
end

# README の h1 をページタイトルに使う
def markdown_title(path, fallback)
  line = File.foreach(path).find { |l| l.start_with?("# ") }
  line ? line.sub(/\A#\s*/, "").strip : fallback
end

# --- HTML -------------------------------------------------------------------

def esc(text) = CGI.escapeHTML(text)

def page(title:, css:, header:, body:)
  <<~HTML
    <!DOCTYPE html>
    <html lang="ja">
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>#{esc(title)}</title>
    <link rel="stylesheet" href="#{css}">
    </head>
    <body>
    #{header}
    <main>
    #{body}
    </main>
    </body>
    </html>
  HTML
end

# 段階ページに並べる生成物。out/ から共通アセットを除いたもの
def artifacts(stage)
  out = File.join(ROOT, stage, "out")
  return [] unless File.directory?(out)

  Dir.children(out)
     .reject { |name| ASSET_DIRS.include?(name) }
     .select { |name| File.file?(File.join(out, name)) }
     .sort
end

def artifact_section(stage)
  files = artifacts(stage)
  if files.empty?
    return <<~HTML
      <section class="artifacts">
      <h2>生成されたレポート</h2>
      <p class="empty">この段階には生成物がない。</p>
      </section>
    HTML
  end

  reports, others = files.partition { |name| File.extname(name) == ".html" }

  list = ->(names, klass) do
    items = names.map { |name| %(<li><a class="#{klass}" href="out/#{name}">#{esc(name)}</a></li>) }
    "<ul class=\"artifact-list\">\n#{items.join("\n")}\n</ul>"
  end

  parts = ["<section class=\"artifacts\">", "<h2>生成されたレポート</h2>"]
  parts << list.call(reports, "report") unless reports.empty?
  unless others.empty?
    parts << "<h3>その他の生成物</h3>"
    parts << list.call(others, "file")
  end
  parts << "</section>"
  parts.join("\n")
end

# tjp / tji はコメントが教材の本体なので、そのまま読めるように載せる。
# エントリポイントだけ開いた状態にする
def source_section(stage)
  entry = File.basename(entrypoint(stage))
  files = Dir.glob(File.join(ROOT, stage, "*.{tjp,tji}"))
              .map { |path| File.basename(path) }
              .sort_by { |name| [name == entry ? 0 : 1, name] }
  return "" if files.empty?

  blocks = files.map do |name|
    code = esc(File.read(File.join(ROOT, stage, name)))
    open = name == entry ? " open" : ""
    <<~HTML.strip
      <details class="source"#{open}>
      <summary>#{esc(name)}</summary>
      <pre><code>#{code}</code></pre>
      </details>
    HTML
  end

  <<~HTML
    <section class="sources">
    <h2>ソース</h2>
    #{blocks.join("\n")}
    </section>
  HTML
end

def build_stage(stage, output)
  readme = File.join(ROOT, stage, "README.md")
  abort "#{stage}: README.md が無い" unless File.exist?(readme)

  dest = File.join(output, stage)
  FileUtils.mkdir_p(dest)

  # tj3 の生成物はアセットの相対パスごとそのまま持ってくる
  out = File.join(ROOT, stage, "out")
  if File.directory?(out)
    FileUtils.rm_rf(File.join(dest, "out"))
    FileUtils.cp_r(out, dest)
  end

  title = markdown_title(readme, stage)
  readme_html, nav = split_nav(markdown_to_html(readme))
  body = [
    %(<article class="readme">\n#{readme_html}</article>),
    artifact_section(stage),
    source_section(stage),
    nav.empty? ? "" : %(<footer class="stage-nav">\n#{nav}</footer>)
  ].reject(&:empty?).join("\n")

  header = <<~HTML.strip
    <header class="site-header">
    <a class="home" href="../">TaskJuggler Playground</a>
    <span class="stage-id">#{esc(stage)}</span>
    </header>
  HTML

  File.write(
    File.join(dest, "index.html"),
    page(title: "#{title} — TaskJuggler Playground", css: "../assets/style.css", header:, body:)
  )
  warn "built #{dest}/index.html"
end

def build_index(output)
  readme = File.join(ROOT, "README.md")
  title = markdown_title(readme, "TaskJuggler Playground")

  header = <<~HTML.strip
    <header class="site-header">
    <span class="home">TaskJuggler Playground</span>
    </header>
  HTML

  FileUtils.mkdir_p(output)
  File.write(
    File.join(output, "index.html"),
    page(
      title:,
      css: "assets/style.css",
      header:,
      body: %(<article class="readme">\n#{markdown_to_html(readme)}</article>)
    )
  )

  FileUtils.mkdir_p(File.join(output, "assets"))
  FileUtils.cp(File.join(ROOT, "tools", "site.css"), File.join(output, "assets", "style.css"))
  warn "built #{output}/index.html"
end

# --- CLI --------------------------------------------------------------------

def take_output(args)
  index = args.index("--output")
  return "site" unless index

  args.delete_at(index)
  args.delete_at(index) or abort "--output に出力先が無い"
end

args = ARGV.dup
command = args.shift
output = take_output(args)

case command
when "stages"     then puts JSON.generate(stage_dirs)
when "entrypoint" then puts entrypoint(args.fetch(0) { abort "usage: build-site.rb entrypoint <段階ディレクトリ>" })
when "stage"      then build_stage(args.fetch(0) { abort "usage: build-site.rb stage <段階ディレクトリ>" }, output)
when "index"      then build_index(output)
else
  abort <<~USAGE
    usage: ruby tools/build-site.rb <command>

      stages                       段階ディレクトリの一覧を JSON で出力
      entrypoint <段階>            tj3 に渡すファイルパスを出力
      stage <段階> [--output DIR]  段階ページを生成 (要 tj3 実行済み)
      index [--output DIR]         トップページと共通 CSS を生成
  USAGE
end
