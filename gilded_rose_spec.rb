require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    context 'When the item is regular' do
      let (:item) {Item.new('Item', 50, 50)}

      example 'The system reduces the shelf life' do
        expect {
          GildedRose.new([item]).update_quality
        }.to change { item.sell_in }.from(50).to(49)
      end

      example 'The system reduces quality' do
        expect {
          GildedRose.new([item]).update_quality
        }.to change { item.quality }.from(50).to(49)
      end

      example 'The quality of a product can never be negative' do
        item = Item.new('Item', 30, 0)

        expect {
          GildedRose.new([item]).update_quality
        }.not_to change { item.quality }
      end
    end

    context 'When the item "Backstage passes"' do
      let (:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 30, 30) }

      example 'The quality of "Backstage passes" increases as it approaches the expiration date' do
        expect {
          GildedRose.new([backstage_pass]).update_quality
        }.to change { backstage_pass.quality }.from(30).to(31)
      end

      example 'The system reduces the shelf life' do
        expect {
          GildedRose.new([backstage_pass]).update_quality
        }.to change { backstage_pass.sell_in }.from(30).to(29)
      end

      example 'Quality increases by 2 when the expiration date is 10 days or less' do
        backstage_pass = Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 30)

        expect {
          GildedRose.new([backstage_pass]).update_quality
        }.to change { backstage_pass.quality }.from(30).to(32)
      end

      example 'Quality increases by 3 when there are 5 days or less before the expiration date' do
        backstage_pass = Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 30)

        expect {
          GildedRose.new([backstage_pass]).update_quality
        }.to change { backstage_pass.quality }.from(30).to(33)
      end

      example 'The quality of the goods can never be more than 50' do
        backstage_pass = Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 50)

        expect {
          GildedRose.new([backstage_pass]).update_quality
        }.not_to change { backstage_pass.quality }
      end
    end

    context 'When the item "Aged Brie"' do
      let (:aged_brie) { Item.new('Aged Brie', 30, 30)}

      example 'The quality of "Aged Brie" increases as it approaches the expiration date' do
        expect {
          GildedRose.new([aged_brie]).update_quality
        }.to change { aged_brie.quality }.from(30).to(31)
      end

      example 'The system reduces the shelf life' do
        expect {
          GildedRose.new([aged_brie]).update_quality
        }.to change { aged_brie.sell_in }.from(30).to(29)
      end

      example 'The quality of the goods can never be more than 50' do
        aged_brie = Item.new('Aged Brie', 5, 50)

        expect {
          GildedRose.new([aged_brie]).update_quality
        }.not_to change { aged_brie.quality }
      end
    end

    context 'When the item "Sulfuras"' do
      let (:sulfuras) { Item.new('Sulfuras, Hand of Ragnaros', 30, 80)}

      example 'Not subject to quality degradation' do
        expect {
          GildedRose.new([sulfuras]).update_quality
        }.not_to change { sulfuras.quality }
      end

      example 'No shelf life' do
        expect {
          GildedRose.new([sulfuras]).update_quality
        }.not_to change { sulfuras.sell_in }
      end
    end

    context 'When the expiration date has passed' do
      context 'When the item "Backstage passes to a TAFKAL80ETC concert"' do
        example 'Quality drops to 0 after the concert date' do
          backstage_pass = Item.new('Backstage passes to a TAFKAL80ETC concert', -1, 50)

          expect {
            GildedRose.new([backstage_pass]).update_quality
          }.to change { backstage_pass.quality }.from(50).to(0)
        end
      end

      context 'When the item "Aged Brie"' do
        example 'Quality increases with age' do
          aged_brie = Item.new('Aged Brie', -1, 30)

          expect {
            GildedRose.new([aged_brie]).update_quality
          }.to change { aged_brie.quality }.from(30).to(32)
        end
      end

      context 'When the item "Conjured"' do
        example 'Quality increases with age' do
          conjured = Item.new('Conjured', -1, 30)

          expect {
            GildedRose.new([conjured]).update_quality
          }.to change { conjured.quality }.from(30).to(26)
        end
      end

      context 'When the item is regular' do
        example 'Item quality deteriorates twice as fast' do
          item = Item.new('Item', -1, 30)

          expect {
            GildedRose.new([item]).update_quality
          }.to change { item.quality }.from(30).to(28)
        end
      end

      example 'The quality of a product can never be negative' do
        item = Item.new('Item', -1, 0)

        expect {
          GildedRose.new([item]).update_quality
        }.not_to change { item.quality }
      end
    end

    context 'When the item "Conjured"' do
      let (:conjured) { Item.new('Conjured', 30, 30) }

      example 'Item quality deteriorates twice as fast' do
        expect {
          GildedRose.new([conjured]).update_quality
        }.to change { conjured.quality }.from(30).to(28)
      end

      example 'The system reduces the shelf life' do
        expect {
          GildedRose.new([conjured]).update_quality
        }.to change { conjured.sell_in }.from(30).to(29)
      end
    end
  end

end
