Puppet::Functions.create_function(:'dconf::any_to_dconf_value') do
  dispatch :any_to_dconf_value do
    param "Any", :something
    return_type "String"
  end

  def any_to_dconf_value(something)
    something.inspect
  end
end
