class DataModel

  attr_reader :id, :words, :weight

  def initialize(id,words)
    @id = id
    @words = words
    @weight = {}
  end

  def assign_weights(max)
    # assigns weight to each work based on max number of words
    for word in words
      if weight[word].nil?
        weight[word] = max
        max = max - 1
      end
    end
  end
end