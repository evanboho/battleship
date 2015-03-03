class Guesser
  attr_accessor :spaces
  attr_accessor :difficulty

  def initialize(init_spaces, difficulty=2)
    self.spaces = init_spaces
    self.difficulty = difficulty
  end

  def run!
    guess = nil
    measure = Benchmark.measure do
      guess = educated || find_boat || random
    end
    puts measure.total
    guess
  end

  def educated
    return unless difficulty >= 2
    guesses = []
    hit_coords.each do |hit|
      hit_neighbor_coords = (hit.neighbors - guessed_coords) & hit_coords
      if hit_neighbor_coords.count == 1
        opposite_neighbor = try_opposite_neighbor(hit)
        guesses << opposite_neighbor if opposite_neighbor
      elsif hit_neighbor_coords.count == 0
        guesses = (hit.neighbors - not_boat_coords) & Board.grid
      end
      break if guesses.present?
    end
    guesses.sample
  end

  def find_boat
    return unless difficulty >= 3
    r = rand
    if difficulty == 3
      return if rand > 0.25
    else
      return if rand > 0.5
    end
    spaces.boats.sample.coords
  end

  def hit_coords
    @hit_coords ||= spaces.hits.map(&:coords)
  end

  def not_boat_coords
    @not_boat_coords ||= spaces.where.not(state: 'boat').map(&:coords)
  end

  def unguessed_coords
    @unguessed_coords ||= (Board.grid - guessed_coords) - spaces.hits.map(&:coords)
  end

  def guessed_coords
    @guessed_coords ||= spaces.guessed.map(&:coords)
  end

  def viable_spaces
    unguessed_coords - loners
  end

  def unguessed_space_neighbors
    unguessed_coords.inject(:+).delete_if { |a| !a.in? Board.grid }
  end

  def random
    viable_spaces.sample
  end

  def loners
    # don't guess these! they don't have any friends!
    @loners ||= unguessed_coords.map do |coords|
      neighbors = coords.neighbors
      coords if (coords.neighbors & guessed_coords).count == coords.neighbors.count
    end.compact
  end

  def space_coords
    spaces.map(&:coords)
  end

  def try_opposite_neighbor(hit)
    hit_neighbor_coords = (hit.neighbors - guessed_coords) & hit_coords
    hit_neighbor = hit_coords.detect { |a| hit_neighbor_coords.first == a }
    neighbor_dir = hit.which_neighbor(hit_neighbor)
    opposite_neighbor_guess = hit.opposite_neighbor(neighbor_dir)
    if opposite_neighbor_guess.in?(Board.grid) && !opposite_neighbor_guess.in?(not_boat_coords)
      hit.opposite_neighbor(neighbor_dir)
    end
  end

end
