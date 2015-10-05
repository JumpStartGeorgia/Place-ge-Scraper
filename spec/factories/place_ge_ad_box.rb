module PlaceGeAdBoxFactory
  def self.build
    new_place_ge_ad_box = PlaceGeAdBox.new('fake_html')
    new_place_ge_ad_box.id = 123_456
    new_place_ge_ad_box
  end
end
