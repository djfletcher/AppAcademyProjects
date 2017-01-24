class Array

  def my_each(&prc)
    i = 0
    while i < self.size
      prc.call(self[i])
      i += 1
    end

    self
  end

  def my_select(&prc)
    result = []
    self.my_each do |el|
      result << el if prc.call(el)
    end

    result
  end

  def my_reject(&prc)
    result = []
    self.my_each do |el|
      result << el unless prc.call(el)
    end

    result
  end

  def my_any?(&prc)
    self.my_each do |el|
      return true if prc.call(el)
    end
    false
  end

  def my_all?(&prc)
    self.my_each do |el|
      return false unless prc.call(el)
    end
    true
  end

  def my_flatten
    result = []
    self.my_each do |el|
      if el.is_a?(Array)
        result += el.my_flatten
      else
        result << el
      end
    end
    result
  end

  def my_zip(*args)
    result = Array.new(self.size) { Array.new(args.size + 1) }
    unzipped_array = [self] + args
    (0...self.size).to_a.my_each do |outer_index|
      (0...unzipped_array.size).to_a.my_each do |inner_index|
        result[outer_index][inner_index] = unzipped_array[inner_index][outer_index]
      end
    end

    result
  end

  def my_rotate(shift = 1)
    result = self.dup

    shift.abs.times do
      if shift > 0
        result << result.shift
      else
        result.unshift(result.pop)
      end
    end
    result
  end

  def my_join(deliminator = "")
    joined_string = ""
    self.my_each do |substring|
      joined_string << substring + deliminator
    end

    joined_string.chomp(deliminator)
  end

  def my_reverse
    reversed = []
    self.my_each do |el|
      reversed.unshift(el)
    end

    reversed
  end

end
