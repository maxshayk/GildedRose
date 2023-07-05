class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        if item.quality < 50
          quality = 1
          quality = 2 if item.sell_in < 0

          increase_quality(item, quality)
        end
      when 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality < 50 && item.sell_in > -1
          quality = 1
          quality = 2 if item.sell_in < 11
          quality = 3 if item.sell_in < 6

          increase_quality(item, quality)
        end

        reduce_quality(item, item.quality) if item.sell_in < 0
      when 'Sulfuras, Hand of Ragnaros'
      when 'Conjured'
        if item.quality > 0
          quality = 2
          quality = 4 if item.sell_in < 0

          reduce_quality(item, quality)
        end
      else
        if item.quality > 0
          quality = 1
          quality = 2 if item.sell_in < 0

          reduce_quality(item, quality)
        end
      end

      update_sell_in(item)
    end
  end

  private

  def update_sell_in(item)
    return if item.name == 'Sulfuras, Hand of Ragnaros'

    item.sell_in -= 1
  end

  def reduce_quality(item, quality)
    item.quality -= quality
  end

  def increase_quality(item, quality)
    item.quality += quality
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
