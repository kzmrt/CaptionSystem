# == Schema Information
#
# Table name: captions
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer
#  title      :string(255)
#  size       :string(255)
#  supplies   :string(255)
#  price      :string(255)
#  memo       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

class Caption < ApplicationRecord
  belongs_to :user, inverse_of: :captions
  validates :title, presence: true
  validates :name, presence: true
  validates :size, presence: true
  validates :supplies, presence: true
  validates :price, presence: true
end
