class ChangeHtmlCopyPathExtensions < ActiveRecord::Migration
  def up
    AdEntry.transaction do
      AdEntry.all.each do |ad_entry|
        if ad_entry.html_copy_path.split(//).last(5).join('').to_s == '.html'
          ad_entry.html_copy_path << '.tar.bz2'
          ad_entry.save!
        end
      end
    end
  end

  def down
  end
end
