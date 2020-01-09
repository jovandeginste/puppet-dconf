Puppet::Functions.create_function(:'dconf::any_to_dconf_value') do
  dispatch :any_to_dconf_value do
    param "Any", :something
    return_type "String"
  end

  def any_to_dconf_value(something)
    if something.is_a?(String) && something[0] == "="
      return something
    end

    something.inspect
  end
end
