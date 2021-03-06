require "test/unit"
require 'digest/md5'
require 'yaml'

ENV['FMINER_LAZAR'] = '1'
ENV['FMINER_SMARTS'] = '1'
ENV['FMINER_SILENT'] = '1'

$fminer_file=File.expand_path(File.dirname(__FILE__)) + "/fminer.rb"
begin
  require $fminer_file
rescue Exception
  puts File.new(__FILE__).path + ": file '#{$fminer_file}' not found!"
  exit false
end
$myFminer=RubyFminer.new()

# A Test class for Fminer/BBRC
class TestFminer < Test::Unit::TestCase
  def initialize(foo)
    super(foo)
    configure
  end

  # Determines default configuration, such as paths
  def configure
    @arch=`uname -m`.chomp
    @smi_file=File.expand_path(File.dirname(__FILE__)) + "/hamster_carcinogenicity.smi"
    @class_file=File.expand_path(File.dirname(__FILE__)) + "/hamster_carcinogenicity.class"
    @class_file_mn=File.expand_path(File.dirname(__FILE__)) + "/hamster_carcinogenicity-multinomial.class"
    @smi_regr_file=File.expand_path(File.dirname(__FILE__)) + "/EPAFHM.smi"
    @class_regr_file=File.expand_path(File.dirname(__FILE__)) + "/EPAFHM.act"
    @md5_yaml_file=File.expand_path(File.dirname(__FILE__)) + "/fminer_md5.yaml"
    @config=nil
    begin
      @config = YAML.load_file(@md5_yaml_file)
    rescue Exception
      puts File.new(__FILE__).path + ": file '#{@md5_yaml_file}' could not be loaded!"
      exit false
    end
  end

  # Tests default Fminer settings 
  def test_ruby_fminer
    output=$myFminer.run_fminer(@smi_file, @class_file, 2)
    File.open("default","w"){|f|f.puts output}
    actual_md5=Digest::MD5.hexdigest(output)
    expected_md5=@config[@arch]['default']
    assert_equal(actual_md5, expected_md5)
  end

  # Tests multinomial Fminer settings 
  def test_ruby_fminer_multinomial
    output=$myFminer.run_fminer(@smi_file, @class_file_mn, 5)
    File.open("multinomial","w"){|f|f.puts output}
    actual_md5=Digest::MD5.hexdigest(output)
    expected_md5=@config[@arch]['multinomial']
    assert_equal(actual_md5, expected_md5)
  end

  # Tests Kekule representation
  def test_ruby_fminer_kekule
    output=$myFminer.run_fminer(@smi_file, @class_file, 2, false)
    File.open("kekule","w"){|f|f.puts output}
    actual_md5=Digest::MD5.hexdigest(output)
    expected_md5=@config[@arch]['kekule']
    assert_equal(actual_md5, expected_md5)
  end

  # Tests Regression
  def test_ruby_fminer_regression
    output=$myFminer.run_fminer(@smi_regr_file, @class_regr_file, 5, true, true)
    File.open("regression","w"){|f|f.puts output}
    actual_md5=Digest::MD5.hexdigest(output)
    expected_md5=@config[@arch]['regression']
    assert_equal(actual_md5, expected_md5)
  end

end
