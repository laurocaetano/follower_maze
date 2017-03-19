defmodule FollowerMaze.Registries.FollowersTest do
  use ExUnit.Case, async: true

  alias FollowerMaze.Registries.Followers

  setup do
    Followers.start_link
    :ok
  end

  test "adds follower" do
    user = "1"
    follower = "2"

    Followers.follow(user, follower)

    assert Followers.followers_of(user) == MapSet.put(MapSet.new, follower)
  end

  test "removes follower" do
    user = "1"
    follower_1 = "2"
    follower_2 = "3"

    Followers.follow(user, follower_1)
    Followers.follow(user, follower_2)
    Followers.unfollow(user, follower_1)

    assert Followers.followers_of(user) == MapSet.put(MapSet.new, follower_2)
  end
end
