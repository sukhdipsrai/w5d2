# == Schema Information
#
# Table name: albums
#
#  asin        :string       not null, primary key
#  title       :string
#  artist      :string
#  price       :float
#  rdate       :date
#  label       :string
#  rank        :integer
#
# Table name: styles
#
# album        :string       not null
# style        :string       not null
#
# Table name: tracks
# album        :string       not null
# disk         :integer      not null
# posn         :integer      not null
# song         :string

require_relative './sqlzoo.rb'

def alison_artist
  # Select the name of the artist who recorded the song 'Alison'.
  execute(<<-SQL)
  SELECT a.artist
  FROM albums a
  JOIN tracks t
  ON t.album = a.asin
  WHERE t.song = 'Alison'
  SQL
end

def exodus_artist
  # Select the name of the artist who recorded the song 'Exodus'.
  execute(<<-SQL)
  SELECT a.artist
  FROM albums a
  JOIN tracks t
  ON t.album = a.asin
  WHERE t.song = 'Exodus'
  SQL
end

def blur_songs
  # Select the `song` for each `track` on the album `Blur`.
  execute(<<-SQL)
  SELECT t.song
  FROM albums a
  JOIN tracks t
  ON t.album = a.asin
  WHERE a.title = 'Blur'
  SQL
end

def heart_tracks
  # For each album show the title and the total number of tracks containing
  # the word 'Heart' (albums with no such tracks need not be shown). Order first by
  # the number of such tracks, then by album title.
  execute(<<-SQL)
  SELECT a.title, COUNT(*)
  FROM albums a
  JOIN tracks t
  ON t.album = a.asin
  WHERE t.song LIKE '%Heart%'
  GROUP BY a.title
  ORDER BY COUNT(*) DESC,a.title
  SQL
end

def title_tracks
  # A 'title track' has a `song` that is the same as its album's `title`. Select
  # the names of all the title tracks.
  execute(<<-SQL)
  SELECT t.song
  FROM albums a
  JOIN tracks t
  ON t.album = a.asin
  WHERE t.song = a.title
  SQL
end

def eponymous_albums
  # An 'eponymous album' has a `title` that is the same as its recording
  # artist's name. Select the titles of all the eponymous albums.
  execute(<<-SQL)
  SELECT a.title
  FROM albums a
  WHERE a.artist = a.title
  SQL
end

def song_title_counts
  # Select the song names that appear on more than two albums. Also select the
  # COUNT of times they show up.
  execute(<<-SQL)
  SELECT t.song , COUNT(a.asin)
  FROM albums a
  JOIN tracks t
  ON t.album = a.asin
  GROUP BY t.song
  HAVING COUNT(DISTINCT a.asin) > 2
  SQL
end

def best_value
  # A "good value" album is one where the price per track is less than 50
  # pence. Find the good value albums - show the title, the price and the number
  # of tracks.
  execute(<<-SQL)
  SELECT DISTINCT a.title, a.price, COUNT(t.song)
  FROM albums a
  JOIN tracks t ON t.album = a.asin
  GROUP BY a.asin, a.title, a.price
  HAVING (a.price/COUNT(t.song)) < .50
  SQL
end

def top_track_counts
  # Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101
  # tracks. List the top 10 albums. Select both the album title and the track
  # count, and order by both track count and title (descending).
  execute(<<-SQL)
  SELECT a.title, COUNT(t.song)
  FROM albums AS a
  JOIN tracks AS t ON a.asin = t.album
  GROUP BY a.asin,a.title
  ORDER BY COUNT(t.song) DESC, a.title DESC
  LIMIT 10
  SQL
end

def rock_superstars
  # Select the artist who has recorded the most rock albums, as well as the
  # number of albums. HINT: use LIKE '%Rock%' in your query.
  execute(<<-SQL)
  SELECT a.artist, COUNT(DISTINCT a.asin)
  FROM tracks t
  JOIN albums a ON t.album = a.asin
  JOIN styles s ON s.album = a.asin
  WHERE s.style LIKE '%Rock%'
  GROUP BY a.artist
  ORDER BY COUNT(*) DESC
  LIMIT 1
  SQL
end

def expensive_tastes
  # Select the five styles of music with the highest average price per track,
  # along with the price per track. One or more of each aggregate functions,
  # subqueries, and joins will be required.
  #
  # HINT: Start by getting the number of tracks per album. You can do this in a
  # subquery. Next, JOIN the styles table to this result and use aggregates to
  # determine the average price per track.
  execute(<<-SQL)
    SELECT DISTINCT s.style , SUM(a_with_p.track_price)/COUNT(t.song) as ppt
    FROM (SELECT a.asin, a.price/COUNT(t.song) as track_price
          FROM tracks t
          JOIN albums a ON t.album = a.asin
          GROUP BY a.asin) as a_with_p
    JOIN tracks t ON a_with_p.asin = t.album
    JOIN styles s ON t.album = s.album
    GROUP BY s.style
    HAVING SUM(a_with_p.track_price)/COUNT(t.song) is not null
    ORDER BY ppt DESC
    LIMIT 5
  SQL
end
