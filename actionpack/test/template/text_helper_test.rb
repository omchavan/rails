require 'test/unit'
require File.dirname(__FILE__) + '/../../lib/action_view/helpers/text_helper'
require File.dirname(__FILE__) + '/../../../activesupport/lib/active_support/core_ext/numeric'  # for human_size

class TextHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TextHelper
  
  def test_simple_format
    assert_equal "<p>crazy\n<br /> cross\n<br /> platform linebreaks</p>", simple_format("crazy\r\n cross\r platform linebreaks")
    assert_equal "<p>A paragraph</p>\n\n<p>and another one!</p>", simple_format("A paragraph\n\nand another one!")
    assert_equal "<p>A paragraph\n<br /> With a newline</p>", simple_format("A paragraph\n With a newline")
  end

  def test_truncate
    assert_equal "Hello World!", truncate("Hello World!", 12)
    assert_equal "Hello Worl...", truncate("Hello World!!", 12)
  end

  def test_strip_links
    assert_equal "on my mind", strip_links("<a href='almost'>on my mind</a>")
  end

  def test_highlighter
    assert_equal(
      "This is a <strong class=\"highlight\">beautiful</strong> morning",
      highlight("This is a beautiful morning", "beautiful")
    )

    assert_equal(
      "This is a <strong class=\"highlight\">beautiful</strong> morning, but also a <strong class=\"highlight\">beautiful</strong> day",
      highlight("This is a beautiful morning, but also a beautiful day", "beautiful")
    )

    assert_equal(
      "This is a <b>beautiful</b> morning, but also a <b>beautiful</b> day",
      highlight("This is a beautiful morning, but also a beautiful day", "beautiful", '<b>\1</b>')
    )
  end

  def test_highlighter_with_regexp
    assert_equal(
      "This is a <strong class=\"highlight\">beautiful!</strong> morning",
      highlight("This is a beautiful! morning", "beautiful!")
    )

    assert_equal(
      "This is a <strong class=\"highlight\">beautiful! morning</strong>",
      highlight("This is a beautiful! morning", "beautiful! morning")
    )

    assert_equal(
      "This is a <strong class=\"highlight\">beautiful? morning</strong>",
      highlight("This is a beautiful? morning", "beautiful? morning")
    )
  end

  def test_excerpt
    assert_equal("...is a beautiful morni...", excerpt("This is a beautiful morning", "beautiful", 5))
    assert_equal("This is a...", excerpt("This is a beautiful morning", "this", 5))
    assert_equal("...iful morning", excerpt("This is a beautiful morning", "morning", 5))
    assert_equal("...iful morning", excerpt("This is a beautiful morning", "morning", 5))
    assert_nil excerpt("This is a beautiful morning", "day")
  end

  def test_pluralization
    assert_equal("1 count", pluralize(1, "count"))
    assert_equal("2 counts", pluralize(2, "count"))
  end

  def test_auto_linking
    email_raw    = 'david@loudthinking.com'
    email_result = %{<a href="mailto:#{email_raw}">#{email_raw}</a>}
    link_raw     = 'http://www.rubyonrails.com'
    link_result  = %{<a href="#{link_raw}">#{link_raw}</a>}
    link2_raw    = 'www.rubyonrails.com'
    link2_result = %{<a href="http://#{link2_raw}">#{link2_raw}</a>}

    assert_equal %(hello #{email_result}), auto_link("hello #{email_raw}", :email_addresses)
    assert_equal %(Go to #{link_result}), auto_link("Go to #{link_raw}", :urls)
    assert_equal %(Go to #{link_raw}), auto_link("Go to #{link_raw}", :email_addresses)
    assert_equal %(Go to #{link_result} and say hello to #{email_result}), auto_link("Go to #{link_raw} and say hello to #{email_raw}")
    assert_equal %(<p>Link #{link_result}</p>), auto_link("<p>Link #{link_raw}</p>")
    assert_equal %(<p>#{link_result} Link</p>), auto_link("<p>#{link_raw} Link</p>")
    assert_equal %(Go to #{link2_result}), auto_link("Go to #{link2_raw}", :urls)
    assert_equal %(Go to #{link2_raw}), auto_link("Go to #{link2_raw}", :email_addresses)
    assert_equal %(<p>Link #{link2_result}</p>), auto_link("<p>Link #{link2_raw}</p>")
    assert_equal %(<p>#{link2_result} Link</p>), auto_link("<p>#{link2_raw} Link</p>")
  end
  
end
