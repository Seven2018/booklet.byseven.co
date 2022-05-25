class Objective::IndicatorDecorator < Draper::Decorator
  delegate_all

  def completion
    case
    when boolean? then options['current_value'] == options['target_value'] ? 'Completed' : 'Not completed'
    when numeric_value? then "#{options['current_value']} / #{options['target_value']}"
    when percentage? then "#{options['current_value']}%"
    when multi_choice? then options['current_value']

    end
  end
end
