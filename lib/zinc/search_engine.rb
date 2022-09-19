require_relative "data_model"
require_relative "page"
require_relative "query"

class SearchEngine

  attr_reader :total_pages, :total_queries, :max_words, :words_list, :words, :pages, :queries

  def initialize
    @total_pages = 0
    @total_queries = 0
    @max_words = 0
    @words_list = {}
    @pages = {}
    @queries = []
    read_input
    assign_weights
    search_pages
  end

  def add_to_words_list(obj)
    # function to fill the words_list with words as keys and list of page id, where they have occurred.
    # param1 obj: instance of page

    for word in obj.words
      if words_list[word].nil?
        words_list[word] = [obj.id]
      else
        words_list[word].append(obj.id)
      end
    end
  end

  def get_instance(data)
    # create a instance based on the type

    words = data[1..data.length]
    if data[0] == "p"
      @total_pages += 1
      id = "P#{total_pages}"
      obj = Page.new(id,words)
    else
      @total_queries += 1
      id = "Q#{total_queries}"
      obj = Query.new(id,words)
    end
    obj
  end

  def assign_max_count(count)
    # assign max words with the maximum words per page or query

    @max_words = count > @max_words ? count : @max_words
  end

  def create_model(data)
    obj = get_instance(data)
    assign_max_count(data.length - 1)

    if data[0] == "p"
      @pages[obj.id] = obj
      add_to_words_list obj
    else
      @queries.push obj
    end
  end

  def assign_weights
    # assigns weights to each word of each query and page,
    # based on the maximum number being calculated earlier

    @pages.each { |page_id,page| page.assign_weights(max_words) }
    @queries.each { |query| query.assign_weights(max_words) }
  end

  def search_pages
    # Search For Pages

    for query in @queries
      visited = []
      d = {}

      for word in query.words
        if !@words_list[word].nil?
          for page in @words_list[word]
            unless visited.include?(page)
              visited.push(page)
              page_value = calculate_page_value(query,pages[page])
              d[page] = page_value
            end
          end
        end
      end
      d = d.sort_by {|_key, value| -value}.to_h
      print_result(query.id,d.keys)
    end
  end

  def print_result(q_id, pages)
    # function for printing the result.
    # :param name: Query id
    # :param Dict: Result of pages to be printed
    print "#{q_id}: "
    pages[0..4].each { |page_id| print "#{page_id} "}
    print("\n")
  end


  def calculate_page_value(query, page)
    # function to calculate page value based on the query.
    # :param query: query object
    # :param page: page object
    # :return: page_value

    page_value = 0
    for word in query.words
      if page.words.include? word
        page_value += query.weight[word] * page.weight[word]
      end
    end
    page_value
  end

  def read_input
    # reads input from input.txt file and prints the obtained input in console.

    f = File.open(__dir__ + '/../../input/input.txt','r')
    f.each_line do |line|
      create_model(line.downcase.split())
    end
  end
end