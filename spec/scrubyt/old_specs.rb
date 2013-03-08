it "should be able to submit a form by name" do
  mock_mechanize
  @form.should_receive(:name).and_return("form_one")
  @extractor = Scrubyt::Extractor.new(:agent => :standard) do
    fetch "http://www.google.com/"
    submit :form_name => "form_one"
  end
end

it "should be able to submit a button by displayed value" do
  mock_google_results
  @extractor = Scrubyt::Extractor.new(:agent => :standard) do
    fetch "http://www.google.com/search/index.html?q=something"
    submit "I'm Feeling Lucky"
  end
end

