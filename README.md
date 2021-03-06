Axlsx: Office Open XML Spreadsheet Generation
====================================
[![Build Status](https://secure.travis-ci.org/randym/axlsx.png)](http://travis-ci.org/randym/axlsx/)

**IRC**:          [irc.freenode.net / #axlsx](irc://irc.freenode.net/axlsx)    
**Git**:          [http://github.com/randym/axlsx](http://github.com/randym/axlsx)   
**Author**:       Randy Morgan   
**Copyright**:    2011      
**License**:      MIT License      
**Latest Version**: 1.0.14   
**Ruby Version**: 1.8.7, 1.9.2, 1.9.3 

**Release Date**: December 14th 2011     

Synopsis
--------

Axlsx is an Office Open XML Spreadsheet generator for the Ruby programming language.
With Axlsx you can create excel worksheets with charts, images, automated column width, customizable styles, functins, merged cells and auto filters as well as full schema validation. Axlsx excels at helping you generate beautiful Office Open XML Spreadsheet documents without having to understand the entire ECMA specification.

If you are working in rails, or with active record see:
http://github.com/randym/acts_as_xlsx 

There are guides for using axlsx and acts_as_xlsx here:
[http://axlsx.blogspot.com](http://axlsx.blogspot.com)

Help Wanted
-----------

I'd really like to get rid of the depenency on RMagick in this gem. RMagic is being used to calculate the column widths in a worksheet based on the content the user specified. If there happens to be anyone out there with the background and c skills to write an extenstion that can determine the width of a single character rendered with a specific font at a specific font size please give me a shout.

Feature List
------------
                                                                              
**1. Author xlsx documents: Axlsx is made to let you easily and quickly generate profesional xlsx based reports that can be validated before serialiation.

**2. Generate 3D Pie, Line and Bar Charts: With Axlsx chart generation and management is as easy as a few lines of code. You can build charts based off data in your worksheet or generate charts without any data in your sheet at all.
                                                                              
**3. Custom Styles: With guaranteed document validity, you can style borders, alignment, fills, fonts, and number formats in a single line of code. Those styles can be applied to an entire row, or a single cell anywhere in your workbook.

**4. Automatic type support: Axlsx will automatically determine the type of data you are generating. In this release Float, Integer, String and Time types are automatically identified and serialized to your spreadsheet.

**5. Automatic column widths: Axlsx will automatically determine the appropriate width for your columns based on the content in the worksheet.

**6. Support for automatically formatted 1904 and 1900 epocs configurable in the workbook.

**7. Add jpg, gif and png images to worksheets

**8. Refernce cells in your worksheet with "A1" and "A1:D4" style references or from the workbook using "Sheett1!A3:B4" style references

**9. Cell level style overrides for default and customized style object

**10. Support for formulas

**11. Support for cell merging via worksheet.merged_cells

**12. Auto filtering tables with worksheet.auto_filter

Installing
----------

To install Axlsx, use the following command:

    $ gem install axlsx
    
#Usage
------

     require 'axlsx'

     p = Axlsx::Package.new
     wb = p.workbook

##A Simple Workbook

      wb.add_worksheet(:name => "Basic Worksheet") do |sheet|
        sheet.add_row ["First Column", "Second", "Third"]
        sheet.add_row [1, 2, 3]
      end

##Using Custom Styles

     wb.styles do |s|
       black_cell = s.add_style :bg_color => "00", :fg_color => "FF", :sz => 14, :alignment => { :horizontal=> :center }
       blue_cell =  s.add_style  :bg_color => "0000FF", :fg_color => "FF", :sz => 20, :alignment => { :horizontal=> :center }
       wb.add_worksheet(:name => "Custom Styles") do |sheet|
         sheet.add_row ["Text Autowidth", "Second", "Third"], :style => [black_cell, blue_cell, black_cell]
         sheet.add_row [1, 2, 3], :style => Axlsx::STYLE_THIN_BORDER
       end
     end

##Using Custom Formatting

     wb.styles do |s|
       date = s.add_style(:format_code => "yyyy-mm-dd", :border => Axlsx::STYLE_THIN_BORDER)
       padded = s.add_style(:format_code => "00#", :border => Axlsx::STYLE_THIN_BORDER)
       percent = s.add_style(:format_code => "0000%", :border => Axlsx::STYLE_THIN_BORDER)
       wb.add_worksheet(:name => "Formatting Data") do |sheet|
         sheet.add_row ["Custom Formatted Date", "Percent Formatted Float", "Padded Numbers"], :style => Axlsx::STYLE_THIN_BORDER
         sheet.add_row [Time.now, 0.2, 32], :style => [date, percent, padded]
       end
     end

##Styling Columns

     wb.styles do |s|
       percent = s.add_style :num_fmt => 9
       wb.add_worksheet(:name => "Styling Columns") do |sheet|
         sheet.add_row ['col 1', 'col 2', 'col 3', 'col 4']
         sheet.add_row [1, 2, 0.3, 4]
         sheet.add_row [1, 2, 0.2, 4]
         sheet.add_row [1, 2, 0.1, 4]
         sheet.col_style 2, percent, :row_offset => 1
       end
     end

##Styling Rows

     wb.styles do |s|
       head = s.add_style :bg_color => "00", :fg_color => "FF"
       percent = s.add_style :num_fmt => 9
       wb.add_worksheet(:name => "Styling Rows") do |sheet|
         sheet.add_row ['col 1', 'col 2', 'col 3', 'col 4']
         sheet.add_row [1, 2, 0.3, 4]
         sheet.add_row [1, 2, 0.2, 4]
         sheet.add_row [1, 2, 0.1, 4]
         sheet.col_style 2, percent, :row_offset => 1
         sheet.row_style 0, head
       end
     end

##Styling Cell Overrides

     wb.add_worksheet(:name => "Cell Level Style Overrides") do |sheet|
         # cell level style overides when adding cells
         sheet.add_row ['col 1', 'col 2', 'col 3', 'col 4'], :sz => 16
         sheet.add_row [1, 2, 3, "=SUM(A2:C2)"]
         # cell level style overrides via sheet range
         sheet["A1:D1"].each { |c| c.color = "FF0000"}
         sheet['A1:D2'].each { |c| c.style = Axlsx::STYLE_THIN_BORDER }
     end     

##Add an Image

     wb.add_worksheet(:name => "Images") do |sheet|
       img = File.expand_path('examples/image1.jpeg') 
       sheet.add_image(:image_src => img, :noSelect => true, :noMove => true) do |image|
         image.width=720
         image.height=666
         image.start_at 2, 2
       end
     end  

##Asian Language Support

     wb.add_worksheet(:name => "Unicode Support") do |sheet|
       sheet.add_row ["日本語"]
       sheet.add_row ["华语/華語"]
       sheet.add_row ["한국어/조선말"]
     end  


##Using formula

     wb.add_worksheet(:name => "Using Formulas") do |sheet|
       sheet.add_row ['col 1', 'col 2', 'col 3', 'col 4']
       sheet.add_row [1, 2, 3, "=SUM(A2:C2)"]
     end


##Merging Cells

     wb.add_worksheet(:name => 'Merging Cells') do |sheet|
         # cell level style overides when adding cells
         sheet.add_row ["col 1", "col 2", "col 3", "col 4"], :sz => 16
         sheet.add_row [1, 2, 3, "=SUM(A2:C2)"]
         sheet.add_row [2, 3, 4, "=SUM(A3:C3)"]
         sheet.add_row ["total", "", "", "=SUM(D2:D3)"]
         sheet.merge_cells("A4:C4")
         sheet["A1:D1"].each { |c| c.color = "FF0000"}
         sheet["A1:D4"].each { |c| c.style = Axlsx::STYLE_THIN_BORDER }
     end     

##Generating A Bar Chart

     wb.add_worksheet(:name => "Bar Chart") do |sheet|
       sheet.add_row ["A Simple Bar Chart"]
       sheet.add_row ["First", "Second", "Third"]
       sheet.add_row [1, 2, 3]
       sheet.add_chart(Axlsx::Bar3DChart, :start_at => "A4", :end_at => "F17") do |chart|
         chart.add_series :data => sheet["A3:C3"], :labels => sheet["A2:C2"], :title => sheet["A1"]
       end
     end  

##Generating A Pie Chart

     wb.add_worksheet(:name => "Pie Chart") do |sheet|
       sheet.add_row ["First", "Second", "Third", "Fourth"]
       sheet.add_row [1, 2, 3, "=PRODUCT(A2:C2)"]
       sheet.add_chart(Axlsx::Pie3DChart, :start_at => [0,2], :end_at => [5, 15], :title => "example 3: Pie Chart") do |chart|
         chart.add_series :data => sheet["A2:D2"], :labels => sheet["A1:D1"]
       end
     end  

##Data over time

     wb.add_worksheet(:name=>'Charting Dates') do |sheet|
         # cell level style overides when adding cells
         sheet.add_row ['Date', 'Value'], :sz => 16
         sheet.add_row [Time.now - (7*60*60*24), 3]
         sheet.add_row [Time.now - (6*60*60*24), 7]
         sheet.add_row [Time.now - (5*60*60*24), 18]
         sheet.add_row [Time.now - (4*60*60*24), 1]
         sheet.add_chart(Axlsx::Bar3DChart) do |chart|
            chart.start_at "B7"
            chart.end_at "H27"
            chart.add_series(:data => sheet["B2:B5"], :labels => sheet["A2:A5"], :title => sheet["B1"])           
         end 
     end     

##Generating A Line Chart

     wb.add_worksheet(:name => "Line Chart") do |sheet|
       sheet.add_row ["First", 1, 5, 7, 9]
       sheet.add_row ["Second", 5, 2, 14, 9]
       sheet.add_chart(Axlsx::Line3DChart, :title => "example 6: Line Chart", :rotX => 30, :rotY => 20) do |chart|
         chart.start_at 0, 2
         chart.end_at 10, 15
         chart.add_series :data => sheet["B1:E1"], :title => sheet["A1"]
         chart.add_series :data => sheet["B2:E2"], :title => sheet["A2"]         
       end       
     end  

##Auto Filter

     wb.add_worksheet(:name => "Auto Filter") do |sheet|
       sheet.add_row ["Build Matrix"]
       sheet.add_row ["Build", "Duration", "Finished", "Rvm"]
       sheet.add_row ["19.1", "1 min 32 sec", "about 10 hours ago", "1.8.7"]
       sheet.add_row ["19.2", "1 min 28 sec", "about 10 hours ago", "1.9.2"]
       sheet.add_row ["19.3", "1 min 35 sec", "about 10 hours ago", "1.9.3"]
       sheet.auto_filter = "A2:D5"
     end  

##Validate and Serialize

     p.validate.each { |e| puts e.message }
     p.serialize("example.xlsx")


#Documentation
--------------
This gem is 100% documented with YARD, an exceptional documentation library. To see documentation for this, and all the gems installed on your system use:

      gem install yard
      yard server -g


#Specs
------
This gem has 100% test coverage using test/unit. To execute tests for this gem, simply run rake in the gem directory.
 
#Changelog
---------
- **December.14.11**: 1.0.14 release
   - Added support for merging cells
   - Added support for auto filters
   - Improved auto width calculations
   - Improved charts
   - Updated examples to output to a single workbook with multiple sheets
   - Added access to app and core package objects so you can set the creator and other properties of the package
   - The beginning of password protected xlsx files - roadmapped for January release.
	
- **December.8.11**: 1.0.13 release
   -  Fixing .gemspec errors that caused gem to miss the lib directory. Sorry about that.

- **December.7.11**: 1.0.12 release
    DO NOT USE THIS VERSION = THE GEM IS BROKEN
  - changed dependency from 'zip' gem to 'rubyzip' and added conditional code to force binary encoding to resolve issue with excel 2011
  - Patched bug in app.xml that would ignore user specified properties.
- **December.5.11**: 1.0.11 release
  - Added [] methods to worksheet and workbook to provide name based access to cells.
  - Added support for functions as cell values
  - Updated color creation so that two character shorthand values can be used like 'FF' for 'FFFFFFFF' or 'D8' for 'FFD8D8D8'
  - Examples for all this fun stuff added to the readme
  - Clean up and support for 1.9.2 and travis integration
  - Added support for string based cell referencing to chart start_at and end_at. That means you can now use :start_at=>"A1" when using worksheet.add_chart, or chart.start_at ="A1" in addition to passing a cell or the x, y coordinates.
 
Please see the {file:CHANGELOG.md} document for past release information.


#Copyright and License
----------

Axlsx &copy; 2011 by [Randy Morgan](mailto:digial.ipseity@gmail.com). Axlsx is 
licensed under the MIT license. Please see the {file:LICENSE} document for more information.
