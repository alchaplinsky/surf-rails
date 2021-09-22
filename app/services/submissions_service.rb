class SubmissionsService
  PER_PAGE = 20

  attr_reader :relation, :params

  def initialize(relation, params)
    @relation = relation
    @params = params
  end

  def to_json(oprions = {})
    MultiJson.dump({ results: results, meta: meta })
  end

  private

  def results
    build_relation!
    Api::SubmissionPresenter[1.1].map(relation)
  end

  def build_relation!
    query_relation!
    include_associations!
    order_relation!
    paginate_relation!
  end

  def query_relation!
    return unless params[:query]
    if tag_query.present?
      @relation = relation.joins(:tags).where('tags.name': tag_query)
    end
    unless text_query.empty?
      @relation = relation.where('submissions.text ILIKE ?', "%#{text_query}%")
    end
  end

  def include_associations!
    @relation = relation.includes(:link, :note, :image, :attachment)
  end

  def order_relation!
    @relation = relation.order('submissions.created_at DESC')
  end

  def paginate_relation!
    @relation = relation.page(params[:page]).per(PER_PAGE)
  end

  def tag_query
    @tag_query ||= HashtagsService.parse_tags params[:query]
  end

  def text_query
    @text_qury ||= HashtagsService.without_tags params[:query]
  end

  def meta
    {
      counters: {
        links: links_count,
        notes: notes_count,
        images: images_count,
        attachments: attachments_count
      },
      pagination: {
        total_count: relation.total_count,
        total_pages: relation.total_pages,
        current_page: relation.current_page,
        is_first_page: relation.first_page?,
        is_last_page: relation.last_page?
      }
    }
  end

  def notes_count
    @notes_count ||= relation.count - links_count - images_count - attachments_count
  end

  def links_count
    @links_count ||= relation.where.not('links.id': nil).count
  end

  def images_count
    @images_count ||= relation.where.not('images.id': nil).count
  end

  def attachments_count
    @attachments_count ||= relation.where.not('attachments.id': nil).count
  end
end
