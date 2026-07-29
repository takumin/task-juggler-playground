# 生成された TaskJuggler の HTML レポートから表部分だけを抜き出して表示する。
#
# HTML をそのまま読むと CSS や JavaScript で埋まって結果が見えないため、
# スケジュール結果だけを手早く確認したいときに使う。
#
#   ruby tools/dump-report.rb 01-hello/out/overview.html
#   ruby tools/dump-report.rb 03-resources/out/*.html

if ARGV.empty?
  abort "usage: ruby tools/dump-report.rb <生成された html> [...]"
end

ARGV.each do |path|
  unless File.exist?(path)
    warn "not found: #{path}"
    next
  end

  puts "===== #{path} ====="
  html = File.read(path)

  html.scan(%r{<tr[^>]*>.*?</tr>}m).each do |row|
    cells = row.scan(%r{<t[dh][^>]*>(.*?)</t[dh]>}m).flatten.map do |cell|
      cell.gsub(/<[^>]+>/, " ").gsub("&nbsp;", " ").squeeze(" ").strip
    end
    cells.reject!(&:empty?)
    next if cells.empty?
    puts cells.join(" | ")
  end

  puts
end
