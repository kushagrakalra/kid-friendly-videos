module MemairHelper

  def generate_recommendation_mutation(recommendations)
    raise TypeError, 'generate_recommendation_query expects an array of vidoes' unless recommendations.kind_of?(Array) && !recommendations.empty? && (recommendations.all? {|vid| vid.kind_of?(Recommendation)})
    recommendation_strings = recommendations.map { |recommendation|
      """
        {
          type: video
          source: \"Kid Friendly Videos\"
          priority: #{recommendation.priority}
          expires_at: \"#{recommendation.expires_at}\"
          url: \"https://youtu.be/#{recommendation.yt_id}\"
          title: \"#{recommendation.title.gsub('"', '\"')}\"
          description: \"#{recommendation.description.gsub('"', '\"')}\"
          thumbnail_url: \"#{recommendation.thumbnail_url}\"
          duration: #{recommendation.duration}
          published_at: \"#{recommendation.published_at}\"
        }
      """
    }

    """
      mutation {
        BulkCreate(
          recommendations: [
            #{recommendation_strings.join}
          ]
        )
        {
          id
        }
      }
    """
  end
end
