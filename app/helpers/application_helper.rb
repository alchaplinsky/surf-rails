module ApplicationHelper

  def default_meta_tags
    {
      title: 'SurfApp.io - Organize your ideas and inspiration',
      description: 'Surf app helps you to keep and organize information and personal ideas by your insterests. As we naturally work with data in our mind.',
      keywords: 'surf, surfapp, desktop application, helper, organizer, links, notes, tags, interests',
      fb: {
        app_id: Settings.facebook.app_id
      },
      og: {
        title: 'SurfApp.io - Organize your ideas and inspiration',
        description: 'Surf app helps you to keep and organize information and personal ideas by your insterests. As you naturally work with different kinds of information in your mind.',
        image: image_url('macbook.png'),
        type: 'website',
        url: 'https://surfapp.io',
        site_name: 'SurfApp'
      }
    }
  end
end
