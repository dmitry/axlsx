require 'test/unit'
require 'axlsx.rb'

class TestWorkbook < Test::Unit::TestCase
  def setup    
    p = Axlsx::Package.new
    @wb = p.workbook    
  end

  def teardown
  end

  def test_date1904
    assert_equal(Axlsx::Workbook.date1904, @wb.date1904)
    @wb.date1904 = :false
    assert_equal(Axlsx::Workbook.date1904, @wb.date1904)
    Axlsx::Workbook.date1904 = :true
    assert_equal(Axlsx::Workbook.date1904, @wb.date1904)
  end

  def test_add_worksheet
    assert(@wb.worksheets.empty?, "worbook has no worksheets by default")
    ws = @wb.add_worksheet(:name=>"bob")
    assert_equal(@wb.worksheets.size, 1, "add_worksheet adds a worksheet!")
    assert_equal(@wb.worksheets.first, ws, "the worksheet returned is the worksheet added")
    assert_equal(ws.name, "bob", "name option gets passed to worksheet")
  end
  def test_relationships
    #current relationship size is 1 due to style relation
    assert(@wb.relationships.size == 1)
    @wb.add_worksheet
    assert(@wb.relationships.size == 2)
  end

  def test_to_xml
    schema = Nokogiri::XML::Schema(File.open(Axlsx::SML_XSD))
    doc = Nokogiri::XML(@wb.to_xml)
    errors = []
    schema.validate(doc).each do |error|
      errors.push error
      puts error.message
    end
    assert(errors.empty?, "error free validation")
  end
  def test_range_requires__valid_sheet
    ws = @wb.add_worksheet :name=>'fish'
    ws.add_row [1,2,3]
    ws.add_row [4,5,6]
    assert_raise(ArgumentError, "no sheet name part") { @wb["A1:C2"]}
    assert_equal @wb['fish!A1:C2'].size, 6
  end

  def test_to_xml_adds_worksheet_when_worksheets_is_empty
    assert(@wb.worksheets.empty?)
    @wb.to_xml
    assert(@wb.worksheets.size == 1)
  end


end
