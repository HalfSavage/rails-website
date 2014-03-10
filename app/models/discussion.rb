class Discussion < ActiveRecord::Base
  belongs_to :forum 

  # TODO: fix view to keep duplicates out (if a thread is in > 1 forums it will show up twice, I think)
  scope :most_active, -> {
    joins("inner join discussions_active on discussions_active.id = discussions.id").order("score desc").take(1)
  }

end 