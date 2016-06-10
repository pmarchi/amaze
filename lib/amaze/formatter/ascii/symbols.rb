
module Amaze::Formatter::ASCII::Symbols
  # generic
  def h
    '-'
  end
  
  def v
    '|'
  end
  
  def cor
    '+'
  end
  
  def cen
    '∙'
  end
  
  def p
    '.'
  end
  
  def df
    '/'
  end
  
  def db
    '\\'
  end
  
  # for ortho mazes
  alias_method :squ_h, :h
  alias_method :squ_v, :v
  alias_method :squ_cor, :cor
  alias_method :squ_cen, :cen
  
  # for sigma mazes
  def hex_h
    '_'
  end
  
  alias_method :hex_df, :df
  alias_method :hex_db, :db
  alias_method :hex_p, :p
  
  def hex_p_df
    '´'
  end
  
  def hex_p_db
    '`'
  end
  
  # for delta mazes
  alias_method :tri_h, :h
  alias_method :tri_v, :v
  alias_method :tri_df, :df
  alias_method :tri_db, :db
  alias_method :tri_cor, :cen
  alias_method :tri_cen, :cen
  
  # for upsilon mazes
  alias_method :octo_cor, :cor
  alias_method :octo_cen, :cen
  alias_method :octo_df, :df
  alias_method :octo_db, :db

  def octo_df2
    '´.'
  end
  
  def octo_db2
    '`.'
  end
end