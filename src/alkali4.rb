require 'pg'
require 'natto'
require 'levenshtein'

$cnt_e = 0  # entityの推定回数に使用するカウンタ
$cnt_a = 0  # attributeの推定回数に使用するカウンタ
$match_e = false
$match_a = false

@connect = PG::connect(dbname: 'test1')
@natto = Natto::MeCab.new(userdic: "/home/vagrant/aquarium/dic/alkali.dic")

module Enumerable
  def ngram(n)
    each_cons(n).to_a
  end
end

def input
  puts "問題を作成してください。(例:XのYは何ですか？)"
  print "=> "
  txt = gets.chomp

  noun = Array.new
  @natto.parse(txt) do |n|
    if n.feature =~ /\A名詞,|動詞,/ then
      noun.push(n.surface)
    end
  end

  @e = noun[0]
  @a = noun[1]
end

def search_e
  ents = @connect.exec("select entity from alkali")

  @conf_e = Array.new()
  ents.each do |ent|
    if ld(@e, ent.fetch("entity")) == 0 then
      puts "entity に #{@e} を設定しました。"
      $match_e = true
      @conf_e.clear
      break
    end
    if (0.01..0.50).include?(ld(@e, ent.fetch("entity"))) then
      @conf_e.push(ent.fetch("entity"))
    end
  end
end

def estimate_e
  search_e
  if !@conf_e.empty? then
    if @conf_e.count >= 1 then @conf_e.uniq! end
    puts "もしかして、#{@e} は #{@conf_e.join(" か ")} ですか？"
    if @conf_e.count >= 2 then
      @conf_e.each_with_index {|ce, i| print "[#{i+1}] #{ce}\t" }
      print "[#{@conf_e.count+1}] 該当なし\n"
      ok_e = false
      while !ok_e
        print "番号を入力してください => "
        num = gets.chomp.to_i
        if (1..@conf_e.count+1).include?(num) then
          ok_e = true
          if num != @conf_e.count+1 then
            @e = @conf_e[num-1]
            $match_e = true
            puts "entity に #{@e} を設定しました。"
            puts ""
          else
            if $cnt_e < 2 then
              @e = retype
              $cnt_e += 1
              estimate_e
              if @conf_e.count == 0 then break end
            else
              unknown(@e)
            end
          end
        end
      end
    else
      print "[1] はい\t[2] いいえ\n"
      while !ok_e
        print "番号を入力してください => "
        num = gets.chomp.to_i
        if (1..2).include?(num) then
          ok_e = true
          if num == 1 then
            @e = @conf_e[num-1]
            $match_e = true
            puts "entity に #{@e} を設定しました。"
            puts ""
          else
            puts "タイプミスですか？"
            print "[1] はい\t[2] いいえ\n"
            ok_e = false
            while !ok_e
              print "番号を入力してください => "
              num = gets.chomp.to_i
              if (1..2).include?(num) then
                ok_e = true
                if num == 1 then
                  @e = retype
                  estimate_e
                else
                  unknown(@e)
                end
              end
            end
          end
        end
      end
    end
  else
    if !$match_e then
      unknown(@e)
    end
  end
end

def search_a
  atts = @connect.exec("select attribute from alkali")

  @conf_a = Array.new()
  atts.each do |att|
    if ld(@a, att.fetch("attribute")) == 0 then
      puts "attribute に #{@a} を設定しました。"
      $match_a = true
      @conf_a.clear
      break
    end
    if (0.01..0.50).include?(ld(@a, att.fetch("attribute"))) then
      @conf_a.push(att.fetch("attribute"))
    end
  end
end

def estimate_a
  search_a
  if !@conf_a.empty? then
    if @conf_a.count >= 1 then @conf_a.uniq! end
    puts "もしかして、#{@a} は #{@conf_a.join(" か ")} ですか？"
    if @conf_a.count >= 2 then
      @conf_a.each_with_index {|ca, i| print "[#{i+1}] #{ca}\t" }
      print "[#{@conf_a.count+1}] 該当なし\n"
      ok_a = false
      while !ok_a
        print "番号を入力してください => "
        num = gets.chomp.to_i
        if (1..@conf_a.count+1).include?(num) then
          ok_a = true
          if num != @conf_a.count+1 then
            @a = @conf_a[num-1]
            $match_a = true
            puts "entity に #{@a} を設定しました。"
            puts ""
          else
            if $cnt_a < 2 then
              @a = retype
              $cnt_a += 1
              estimate_a
              if @conf_a.count == 0 then break end
            else
              unknown(@a)
            end
          end
        end
      end
    else
      print "[1] はい\t[2] いいえ\n"
      while !ok_a
        print "番号を入力してください => "
        num = gets.chomp.to_i
        if (1..2).include?(num) then
          ok_a = true
          if num == 1 then
            @a = @conf_a[num-1]
            $match_a = true
            puts "attribute に #{@a} を設定しました。"
            puts ""
          else
            puts "タイプミスですか？"
            print "[1] はい\t[2] いいえ\n"
            ok_a = false
            while !ok_a
              print "番号を入力してください => "
              num = gets.chomp.to_i
              if (1..2).include?(num) then
                ok_a = true
                if num == 1 then
                  @a = retype
                  estimate_a
                else
                  unknown(@a)
                end
              end
            end
          end
        end
      end
    end
  else
    if !$match_a then
      unknown(@a)
    end
  end
end

def check
  estimate_e
  estimate_a
  res = @connect.exec("select * from alkali where entity like '#{@e}' AND attribute like '#{@a}' AND value like '%'")
  if res.to_a.empty? then
    puts "それでは、「#{@e} の #{@a} は何ですか？」以外の問題を作成してみましょう。"
    return false
  else
    puts "それでは、「#{@e} の #{@a} は何ですか？」に対する正答と誤答3つを入力してください。"
    return true
  end
end

def search(e, a, v)
  @connect.exec("select * from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '#{v}'")
end

def right(e, a)
  @connect.exec("select value from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '%'")[0].to_h.fetch("value")
end

def wrong(e, a, v)
  @connect.exec("select value from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '#{v}'")[0].to_h.fetch("value")
end

def message(msg)
  puts ""
  case msg
  when "r"
    puts "正答が間違っています。"
    puts "正しくは、#{@e} の #{@a} は #{right(@e, @a)} です。"
  when "w1"
    puts "誤答1が間違っています。"
    puts "「#{@e} の #{@a} は #{wrong(@e, @a, @w1)}」は正しいです。"
  when "w2"
    puts "誤答2が間違っています。"
    puts "「#{@e} の #{@a} は #{wrong(@e, @a, @w2)}」は正しいです。"
  when "w3"
    puts "誤答3が間違っています。"
    puts "「#{@e} の #{@a} は #{wrong(@e, @a, @w3)}」は正しいです。"
  end
end

def ld(w1, w2)
  Levenshtein.normalized_distance(w1, w2)
end

def retype
  puts "それでは、もう一度入力してください。"
  print "=> "
  ret = gets.chomp
  return ret
end

def unknown(word)
  now = Time.now.strftime("%y%m%d%H%M%S").to_s
  fn = now + ".txt"
  puts "ASQは #{word} について知りません。"
  puts "#{word} について、教えてください。"
  print "=> "
  str = gets.chomp
  pre = "#{word} に関する知識\n"
  File.open(fn, 'w') do |file|
    file.write pre
    file.write str
  end
  puts ""
  puts "#{word} は #{str} ですね。わかりました。"
  puts "教えて頂きありがとうございました。"
  puts ""
end

input
while !check do
  input
end

print "正答 => "
@v = gets.chomp
print "誤答1 => "
@w1 = gets.chomp
print "誤答2 => "
@w2 = gets.chomp
print "誤答3 => "
@w3 = gets.chomp

res1 = search(@e, @a, @v)
res2 = search(@e, @a, @w1)
res3 = search(@e, @a, @w2)
res4 = search(@e, @a, @w3)

puts ""

flag = false
if res1.count == 0 then
    if ld(@v, right(@e, @a)) <= 0.5 then
      #if right(@e, @a).split(/\s*/).ngram(2).flatten.include?(@v) then
        puts "もしかして: #{right(@e, @a)} ですか？"
        print "Yes!(y), No!(n) => "
        c = gets.chomp
        if c == "n" then
          #message("r")
          #flag = true
          input
          while !check do
            input
          end
        end
      #end
    else
      message("r")
      flag = true
    end
end
if res2.count >= 1 then
  message("w1")
  flag = true
end
if res3.count >= 1 then
  message("w2")
  flag = true
end
if res4.count >= 1 then
  message("w3")
  flag = true
end

if flag == false then puts "良い問題ですね。" end

@connect.finish
