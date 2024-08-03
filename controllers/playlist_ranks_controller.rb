class PlaylistRanksController < ApplicationController
  get '/playlist_ranks' do
    player = Player.find(params[:player_id])
    season_id = params.fetch(:season_id)

    unless player.completed_seasons.include?(season_id)
      player.update_season_ranks(Season.find(season_id))
    end

    ranks = player.playlist_ranks.highest_first
      .where(season_id:)
      .preload(:csr_tier, :playlist)
      .map { |pr| playlist_rank_hash(pr) }

    json(ranks)
  end

  private

  def playlist_rank_hash(pr)
    {
      image_url: pr.csr_tier.image_url,
      label: rank_label(pr),
      playlist: pr.playlist.name
    }
  end

  def rank_label(pr)
    if pr.csr_tier.name == 'Champion'
      "Champion #{pr.rank}"
    elsif pr.csr_tier.name == 'Onyx'
      "Onyx #{pr.csr}"
    else
      "#{pr.csr_tier.name} (#{pr.progress_percent}%)"
    end
  end
end
