class Coords < Array

  def initialize(*args)
    arr = get_array(args)
    super arr.map(&:to_s)
  end

  def neighbor(dir)
    case dir
    when 'up'
      self.class.new [(letter.ord - 1).chr, number]
    when 'down'
      self.class.new [(letter.ord + 1).chr, number]
    when 'left'
      self.class.new [letter, (number.to_i - 1).to_s]
    when 'right'
      self.class.new [letter, (number.to_i + 1).to_s]
    end
  end

  def neighbors
    %w(up down left right).map { |dir| neighbor(dir) }
  end

  def which_neighbor(coords)
    %w(up down left right).map do |dir|
      n_coords = neighbor(dir)
      n_coords == coords ? dir : nil
    end.compact.first
  end

  def opposite_neighbor(dir)
    neighbor(Space.get_opposite_direction(dir))
  end

  def letter
    self[0]
  end

  def number
    self[1]
  end

  private

  def get_array(args)
    return args[0] if args[0].is_a?(Array)
    if args[1] # then we're passing in 2 strings
      [args[0], args[1]]
    else # then args[0] is a joined string
      letter = args[0].match(/^\w/).to_s
      number = args[0].match(/\d+$/).to_s
      [letter, number]
    end
  end

end
