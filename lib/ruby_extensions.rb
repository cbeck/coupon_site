
class String  
  def to_jsl
    JavaScript::Literal.new(self)
  end
end

class Hash
    
  def recursively(&block)
    inject({}) do |hash, (key, value)|
      if value.is_a?(Hash)
        hash[key] = value.recursively(&block)
      elsif value.is_a?(Array)
        hash[key] = value.collect {|item| (item.is_a?(Hash)) ? item.recursively(&block) : item }
      else
        hash[key] = value
      end
      yield hash
    end
  end

  def recursively!(&block)
    replace(recursively(&block))
  end
  
  def rec_merge!(other)
    other.each do |key, value|
      myval = self[key]
      if value.is_a?(Hash) && myval.is_a?(Hash)
        myval.rec_merge!(value)
      else
        self[key] = value
      end
    end
    self
  end
end

class Array
  def recursively(&block)
    map do |item|
      if item.is_a?(self.class)
        item.recursively(&block)
      else
        yield item
      end
    end
  end

  def recursively!(&block)
    replace(recursively(&block))
  end
end
