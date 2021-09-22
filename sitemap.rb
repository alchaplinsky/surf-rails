require 'rubygems'
require 'sitemap_generator'
SitemapGenerator::Sitemap.default_host = 'https://surfapp.io'
SitemapGenerator::Sitemap.create do
  add '/features', changefreq: 'weekly', priority: 0.9
  add '/download', changefreq: 'weekly', priority: 0.9
  add '/feedback', changefreq: 'weekly', priority: 0.7
  add '/login', changefreq: 'weekly', priority: 0.7
  add '/signup', changefreq: 'weekly', priority: 0.7
  add '/terms', changefreq: 'weekly', priority: 0.5
  add '/privacy', changefreq: 'weekly', priority: 0.5
end
#SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
