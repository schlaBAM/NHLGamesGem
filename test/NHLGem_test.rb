require 'test_helper'
require 'net/http'
require 'json'
class NHLGemTest < Minitest::Test
  
  def test_that_it_has_a_version_number
    refute_nil ::NHLGem::VERSION
  end

  def test_response
    uri = URI('http://statsapi.web.nhl.com/api/v1/schedule')
    response_code = Net::HTTP.get_response(uri).code
    assert_equal response_code, '200'
  end

  def test_no_games
    games = []
    assert_equal 'There are no games today - well that sucks.', create_result_string(games)
  end

  def test_no_current_games

    games = [{'gamePk' => 2019020782, 'link' => '/api/v1/game/2019020782/feed/live', 'gameType' => 'R', 'season' => '20192020', 'gameDate' => '2020-01-31T00:00:00Z', 'status' => {'abstractGameState' => 'Final', 'codedGameState' => '7', 'detailedState' => 'Final', 'statusCode' => '7', 'startTimeTBD' => false}, 'teams' => {'away' => {'leagueRecord' => {'wins' => 23, 'losses' => 22, 'ot' => 7, 'type' => 'league'}, 'score' => 3, 'team' => {'id' => 8, 'name' => 'Montréal Canadiens', 'link' => '/api/v1/teams/8'}}, 'home' => {'leagueRecord' => {'wins' => 22, 'losses' => 22, 'ot' => 7, 'type' => 'league'}, 'score' => 1, 'team' => {'id' => 7, 'name' => 'Buffalo Sabres', 'link' => '/api/v1/teams/7'}}}, 'venue' => {'id' => 5039, 'name' => 'KeyBank Center', 'link' => '/api/v1/venues/5039'}, 'content' => {'link' => '/api/v1/game/2019020782/content'}},
             {'gamePk' => 2019020783, 'link' => '/api/v1/game/2019020783/feed/live', 'gameType' => 'R', 'season' => '20192020', 'gameDate' => '2020-01-31T00:30:00Z', 'status' => {'abstractGameState' => 'Final', 'codedGameState' => '7', 'detailedState' => 'Final', 'statusCode' => '7', 'startTimeTBD' => false}, 'teams' => {'away' => {'leagueRecord' => {'wins' => 24, 'losses' => 19, 'ot' => 7, 'type' => 'league'}, 'score' => 6, 'team' => {'id' => 18, 'name' => 'Nashville Predators', 'link' => '/api/v1/teams/18'}}, 'home' => {'leagueRecord' => {'wins' => 18, 'losses' => 24, 'ot' => 8, 'type' => 'league'}, 'score' => 5, 'team' => {'id' => 1, 'name' => 'New Jersey Devils', 'link' => '/api/v1/teams/1'}}}, 'venue' => {'name' => 'Prudential Center', 'link' => '/api/v1/venues/null'}, 'content' => {'link' => '/api/v1/game/2019020783/content'}}]

    assert_equal 'There are 2 games today, however all games have ended - check back tomorrow.', create_result_string(games)

  end

  def test_current_games

    games = [{'gamePk' => 2019020782, 'link' => '/api/v1/game/2019020782/feed/live', 'gameType' => 'R', 'season' => '20192020', 'gameDate' => '2020-01-31T00:00:00Z', 'status' => {'abstractGameState' => 'Final', 'codedGameState' => '7', 'detailedState' => 'In Progress', 'statusCode' => '7', 'startTimeTBD' => false}, 'teams' => {'away' => {'leagueRecord' => {'wins' => 23, 'losses' => 22, 'ot' => 7, 'type' => 'league'}, 'score' => 3, 'team' => {'id' => 8, 'name' => 'Montréal Canadiens', 'link' => '/api/v1/teams/8'}}, 'home' => {'leagueRecord' => {'wins' => 22, 'losses' => 22, 'ot' => 7, 'type' => 'league'}, 'score' => 1, 'team' => {'id' => 7, 'name' => 'Buffalo Sabres', 'link' => '/api/v1/teams/7'}}}, 'venue' => {'id' => 5039, 'name' => 'KeyBank Center', 'link' => '/api/v1/venues/5039'}, 'content' => {'link' => '/api/v1/game/2019020782/content'}},
             {'gamePk' => 2019020783, 'link' => '/api/v1/game/2019020783/feed/live', 'gameType' => 'R', 'season' => '20192020', 'gameDate' => '2020-01-31T00:30:00Z', 'status' => {'abstractGameState' => 'Final', 'codedGameState' => '7', 'detailedState' => 'In Progress', 'statusCode' => '7', 'startTimeTBD' => false}, 'teams' => {'away' => {'leagueRecord' => {'wins' => 24, 'losses' => 19, 'ot' => 7, 'type' => 'league'}, 'score' => 6, 'team' => {'id' => 18, 'name' => 'Nashville Predators', 'link' => '/api/v1/teams/18'}}, 'home' => {'leagueRecord' => {'wins' => 18, 'losses' => 24, 'ot' => 8, 'type' => 'league'}, 'score' => 5, 'team' => {'id' => 1, 'name' => 'New Jersey Devils', 'link' => '/api/v1/teams/1'}}}, 'venue' => {'name' => 'Prudential Center', 'link' => '/api/v1/venues/null'}, 'content' => {'link' => '/api/v1/game/2019020783/content'}}]

    in_progress = get_in_progress_games(games)

    assert_equal 'There are 2 games today, and there are currently 2 games in progress:', create_result_string(games, in_progress)

  end

    private

  def get_in_progress_games(games)
    in_progress = []

    games.each do |game|
      in_progress.push(game) if game['status']['detailedState'] == 'In Progress'
    end

    in_progress
  end

  def create_result_string(games, in_progress = [])
    result = ''

    if games.empty?
      result += 'There are no games today - well that sucks.'
    else
      result += "There are #{games.size} games today, "

      result += if in_progress.size > 0
                  "and there are currently #{in_progress.size} games in progress:"
                else
                  'however all games have ended - check back tomorrow.'
                end
    end
    result
  end

  end
