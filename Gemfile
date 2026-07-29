# frozen_string_literal: true

source "https://rubygems.org"

gem "taskjuggler"

# taskjuggler 3.8.4 が require するが、Ruby 3.4 以降で標準添付から外れた gem
gem "base64"
gem "drb"

# tools/build-site.rb が README を HTML に変換するのに使う (GitHub Pages 用)。
# kramdown 本体は ``` のコードブロックを解釈しないため GFM パーサを併せて入れる
gem "kramdown"
gem "kramdown-parser-gfm"
