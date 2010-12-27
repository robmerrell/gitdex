require "app/search"
require "test/unit"
require "shoulda"

class SearchTest < Test::Unit::TestCase

  context 'parsing the "in:" option' do
    should "parse in: rails/rails (with space)" do
      assert_equal %w(rails/rails), Search.parse_in_option("in: rails/rails")
    end
    
    should "parse in:rails/rails (without space)" do
      assert_equal %w(rails/rails), Search.parse_in_option("in:rails/rails")
    end
    
    should "be able to define multiple 'ins:'" do
      repo_terms = Search.parse_in_option("This is a search in:rails/rails and also in in:robmerrell/gitdex")
      
      assert repo_terms.include? "rails/rails"
      assert repo_terms.include? "robmerrell/gitdex"
    end
  end
  
  
  context 'parsing the "between:" option' do
    should "parse between: 2010/01/01 and 2010/12/31 (with space)" do
      between_terms = Search.parse_between_option("search pattern between: 2010/01/01 and 2010/12/31 more search terms")

      assert_equal between_terms[:from], "2010/01/01"
      assert_equal between_terms[:to], "2010/12/31"
    end
    
    should "parse between: 2010/01/01 and 2010/12/31 (without space)" do
      between_terms = Search.parse_between_option("search pattern between:2010/01/01 and 2010/12/31 more search terms")

      assert_equal between_terms[:from], "2010/01/01"
      assert_equal between_terms[:to], "2010/12/31"
    end
  end
  
  
  
end