module Axlsx
  # A NumFmt object defines an identifier and formatting code for data in cells. 
  # @note The recommended way to manage styles is Styles#add_style
  class NumFmt
    # @return [Integer] An unsinged integer referencing a standard or custom number format.
    # @note
    #  These are the known formats I can dig up. The constant NUM_FMT_PERCENT is 9, and uses the default % formatting. Axlsx also defines a few formats for date and time that are commonly used in asia as NUM_FMT_YYYYMMDD and NUM_FRM_YYYYMMDDHHMMSS. 
    #   1 0
    #   2 0.00
    #   3 #,##0
    #   4 #,##0.00
    #   5 $#,##0_);($#,##0)
    #   6 $#,##0_);[Red]($#,##0)
    #   7 $#,##0.00_);($#,##0.00)
    #   8 $#,##0.00_);[Red]($#,##0.00)
    #   9 0%
    #   10 0.00%
    #   11 0.00E+00
    #   12 # ?/?
    #   13 # ??/??
    #   14 m/d/yyyy
    #   15 d-mmm-yy
    #   16 d-mmm
    #   17 mmm-yy
    #   18 h:mm AM/PM
    #   19 h:mm:ss AM/PM
    #   20 h:mm
    #   21 h:mm:ss
    #   22 m/d/yyyy h:mm
    #   37 #,##0_);(#,##0)
    #   38 #,##0_);[Red](#,##0)
    #   39 #,##0.00_);(#,##0.00)
    #   40 #,##0.00_);[Red](#,##0.00)
    #   45 mm:ss
    #   46 [h]:mm:ss
    #   47 mm:ss.0
    #   48 ##0.0E+0
    #   49 @
    # @see Axlsx
    attr_reader :numFmtId

    # @return [String] The formatting to use for this number format. 
    # @see http://support.microsoft.com/kb/264372
    attr_reader :formatCode
    def initialize(options={})
      @numFmtId = 0
      @formatCode = ""
      options.each do |o|
        self.send("#{o[0]}=", o[1]) if self.respond_to? o[0]
      end
    end

    # @see numFmtId
    def numFmtId=(v) Axlsx::validate_unsigned_int v; @numFmtId = v end
    # @see formatCode
    def formatCode=(v) Axlsx::validate_string v; @formatCode = v end

    # Creates a numFmt element applying the instance values of this object as attributes.
    # @param [Nokogiri::XML::Builder] xml The document builder instance this objects xml will be added to.
    def to_xml(xml) xml.numFmt(self.instance_values) end    

  end
end
