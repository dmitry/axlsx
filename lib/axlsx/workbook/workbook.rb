# -*- coding: utf-8 -*-
module Axlsx 

require 'axlsx/workbook/worksheet/cell.rb'
require 'axlsx/workbook/worksheet/row.rb'
require 'axlsx/workbook/worksheet/worksheet.rb'

  # The Workbook class is an xlsx workbook that manages worksheets, charts, drawings and styles.
  # The following parts of the Office Open XML spreadsheet specification are not implimented in this version.
  # 
  #   bookViews
  #   calcPr
  #   customWorkbookViews
  #   definedNames
  #   externalReferences
  #   extLst
  #   fileRecoveryPr
  #   fileSharing
  #   fileVersion
  #   functionGroups
  #   oleSize
  #   pivotCaches
  #   smartTagPr
  #   smartTagTypes
  #   webPublishing
  #   webPublishObjects
  #   workbookProtection
  #   workbookPr*
  #
  #   *workbookPr is only supported to the extend of date1904
  class Workbook

    # A collection of worksheets associated with this workbook. 
    # @note The recommended way to manage worksheets is add_worksheet
    # @see Workbook#add_worksheet
    # @see Worksheet
    # @return [SimpleTypedList]
    attr_reader :worksheets

    # A colllection of charts associated with this workbook
    # @note The recommended way to manage charts is Worksheet#add_chart
    # @see Worksheet#add_chart
    # @see Chart
    # @return [SimpleTypedList]
    attr_reader :charts

    # A colllection of images associated with this workbook
    # @note The recommended way to manage images is Worksheet#add_image
    # @see Worksheet#add_image
    # @see Pic
    # @return [SimpleTypedList]
    attr_reader :images

    # A colllection of drawings associated with this workbook
    # @note The recommended way to manage drawings is Worksheet#add_chart
    # @see Worksheet#add_chart
    # @see Drawing
    # @return [SimpleTypedList]
    attr_reader :drawings

    # The styles associated with this workbook
    # @note The recommended way to manage styles is Styles#add_style
    # @see Style#add_style
    # @see Style
    # @return [Styles]
    def styles
      yield @styles if block_given?
      @styles
    end


    # Indicates if the epoc date for serialization should be 1904. If false, 1900 is used.
    @@date1904 = false

    # lets come back to this later when we are ready for parsing. 
    #def self.parse entry
    #  io = entry.get_input_stream
    #  w = self.new
    #  w.parser_xml = Nokogiri::XML(io.read)
    #  w.parse_string :date1904, "//xmlns:workbookPr/@date1904"      
    #  w
    #end

    # Creates a new Workbook
    # @option options [Boolean] date1904
    def initialize(options={})
      @styles = Styles.new
      @worksheets = SimpleTypedList.new Worksheet
      @drawings = SimpleTypedList.new Drawing
      @charts = SimpleTypedList.new Chart
      @images = SimpleTypedList.new Pic
      self.date1904= options[:date1904] unless options[:date1904].nil?
      yield self if block_given?      
    end

    # Instance level access to the class variable 1904
    # @return [Boolean]
    def date1904() @@date1904; end    

    # see @date1904
    def date1904=(v) Axlsx::validate_boolean v; @@date1904 = v; end

    # Sets the date1904 attribute to the provided boolean
    # @return [Boolean]
    def self.date1904=(v) Axlsx::validate_boolean v; @@date1904 = v; end

    # retrieves the date1904 attribute
    # @return [Boolean]
    def self.date1904() @@date1904; end

    # Adds a worksheet to this workbook
    # @return [Worksheet]
    # @option options [String] name The name of the worksheet.
    # @see Worksheet#initialize
    def add_worksheet(options={})
      worksheet = Worksheet.new(self, options)
      yield worksheet if block_given?
      worksheet
    end

    # The workbook relationships. This is managed automatically by the workbook
    # @return [Relationships]
    def relationships
      r = Relationships.new
      @worksheets.each do |sheet|
        r << Relationship.new(WORKSHEET_R, WORKSHEET_PN % (r.size+1))
      end 
      r << Relationship.new(STYLES_R,  STYLES_PN)
      r
    end

    # returns a range of cells in a worksheet
    # @param [String] cell_def The excel style reference defining the worksheet and cells. The range must specify the sheet to 
    # retrieve the cells from. e.g. range('Sheet1!A1:B2') will return an array of four cells [A1, A2, B1, B2] while range('Sheet1!A1') will return a single Cell.
    # @return [Cell, Array]
    def [](cell_def)
      sheet_name = cell_def.split('!')[0] if cell_def.match('!')
      worksheet =  self.worksheets.select { |s| s.name == sheet_name }.first
      raise ArgumentError, 'Unknown Sheet' unless sheet_name && worksheet.is_a?(Worksheet) 
      worksheet[cell_def.gsub(/.+!/,"")]
    end

    # Serializes the workbook document
    # @return [String]
    def to_xml()
      add_worksheet unless worksheets.size > 0
      builder = Nokogiri::XML::Builder.new(:encoding => ENCODING) do |xml|
        xml.workbook(:xmlns => XML_NS, :'xmlns:r' => XML_NS_R) {
          xml.workbookPr(:date1904=>@@date1904)
          #<x:workbookProtection workbookPassword="xsd:hexBinary data" lockStructure="1" lockWindows="1" />
          xml.sheets {
            @worksheets.each_with_index do |sheet, index|              
              xml.sheet(:name=>sheet.name, :sheetId=>index+1, :"r:id"=>sheet.rId)
            end
          }
        }
      end      
      builder.to_xml(:indent=>0)
    end
  end
end
