module FeatureHelpers

  def should_be_located(path)
    expect(page.current_path).to eq(path)
  end

  def should_see_element(selector, options = {})
    expect(page).to have_css(selector, options)
  end

  def should_not_see_element(selector, options = {})
    expect(page).not_to have_css(selector, options)
  end

  def should_see_link(anchor, href)
    expect(page).to have_link(anchor, href: href)
  end

end
