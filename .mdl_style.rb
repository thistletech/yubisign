all
# Unordered list indentation
exclude_rule 'MD007'
# Ignore line length in code blocks and tables
rule 'MD013', :line_length => 80, :ignore_code_blocks => true, :tables => false
rule 'MD029', :style => :ordered
# Inline HTML
exclude_rule 'MD033'