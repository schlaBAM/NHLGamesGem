require 'NHLGem/version'
require 'net/http'
require 'json'


module NHLGem
  class Error < StandardError; end

  def self.check_games
    url = 'http://statsapi.web.nhl.com/api/v1/schedule'
    uri = URI(url)
    response = Net::HTTP.get(uri)

    games = JSON.parse(response)['dates'][0]['games']

    in_progress = get_in_progress_games(games)

    create_result_string(games, in_progress)
  end


  private

  def get_in_progress_games(games)
    in_progress = []

    games.each do |game|
      if game['status']['detailedState'] == 'In Progress'
        in_progress.push(game)
      end
    end
  end

  def create_result_string(games, in_progress)
    result = ''

    if games.empty?
      result += 'There are no games today - well that sucks.'
    else
      games.size == 1 ? result += "There is #{games.size} game today, " : result += "There are #{games.size} games today, "

      if in_progress.size > 0
        in_progress.size == 1 ? result += "and there is currently #{in_progress.size} game in progress:\n\n"
            : result += "and there are currently #{in_progress.size} games in progress:\n\n"

        in_progress.each do |game|
          home = game['teams']['home']
          away = game['teams']['away']

          home_team = home['team']['name']
          away_team = away['team']['name']

          home_score = home['score']
          away_score = away['score']

          if home_score == away_score
            result += "Tie game! #{home_team} #{home_score}, #{away_team} #{away_score}.\n"
          else
            result += home_score > away_score ? "#{home_team} are currently leading #{away_team} #{home_score}-#{away_team}."
                          : "#{away_team} are currently leading #{home_team} #{away_score}-#{home_score}.\n"
          end
        end
      else
        result += 'however all games have ended - check back tomorrow.'
      end
    end
    result
  end

end
