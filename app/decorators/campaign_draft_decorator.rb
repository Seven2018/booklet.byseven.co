class CampaignDraftDecorator < ApplicationDecorator
  delegate_all

  def progress_state_klass(state, controller_name)
    return 'current' if state.to_s == controller_name

    state_set_or_above?(state) ? 'full' : 'empty'
  end

  def state_set_or_above?(state)
    state_before_type_cast >= object.class.states[state]
  end
end
