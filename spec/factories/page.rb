require 'ostruct'

FactoryBot.define do
  factory :page, class: OpenStruct do
    content_type {'text/html'}
    best_title {'On North Korea – Chris Thomas – Medium'}
    description {'Let’s be clear — North Korea does not want war with the United States and the United States has …'}
    host {'medium.com'}
    url {'https://medium.com/@thegreatkillfile/on-north-korea-ebbbafed762e'}
    images { OpenStruct.new(best: 'https://cdn-images-1.medium.com/max/1200/0*SrD-iw1XF2p45ZO7.jpg') }
  end
end
