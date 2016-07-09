var Measure = React.createClass({
  mixins: [HandleChange, Template],
  getDefaultProps: function() {
    return { id: false,
             title: '',
             description: '',
             yes_means: '',
             no_means: '',
             endorsements: [],
             tags: [] }
  },
  removeTag: function(tag) {
    var tags = _.without(this.props.tags, _.find(this.props.tags, { name: tag }))
    this.setChangedState({ tags: tags })
  },
  addTag: function(tag) {
    var tags = this.state.tags
    tags.push({ name: tag, tagged_id: this.props.id, tagged_type: 'measure' })
    this.setChangedState({ tags: tags })
  },
  getInitialState: function() {
    return { title: this.props.title,
             description: this.props.description,
             yes_means: this.props.yes_means,
             no_means: this.props.no_means,
             endorsements: this.props.endorsements,
             tags: this.props.tags }
  },
  render: function() {
    return <div className="measure mui-col-md-11 measure--form">
      <div className="mui-row">
          <h3>Details</h3>
          <InputComponent name="title"
                          label="Ballot Measure Title"
                          ref='title'
                          value={ this.state.title }
                          onChange={ this.handleChange } />
          <InputComponent name="description"
                          element="textarea"
                          ref='description'
                          label="Description of Measure"
                          value={ this.state.description }
                          onChange={ this.handleChange } />
      </div>
      <div className="mui-row">
        <Taggable tags={this.state.tags}
                  id={this.props.id}
                  tagged_type='Ballot Measure'
                  available_tags={this.props.template.tags}
                  removeTag={this.removeTag}
                  addTag={this.addTag} />
      </div>
      <div className="mui-row mui-panel for--block">
        <h4>In Favor</h4>
        <InputComponent name="yes_means"
                        className="mui-col-md-6"
                        label="What happens if it passes?"
                        element="textarea"
                        value={this.state.yes_means}
                        onChange={this.handleChange} />
        <Endorsements ref="yes_endorsements"
                      className="mui-col-md-5"
                      template={this.props.template}
                      endorsements={this.state.endorsements}
                      handleChange={this.handleChange}
                      endorsed_type='measure'
                      endorsed_id={this.props.id}
                      stance="for" />
      </div>
      <div className="mui-row mui-panel against--block">
        <h4>Against</h4>
        <InputComponent name="no_means"
                        className="mui-col-md-6"
                        label="What happens if it does not pass?"
                        element="textarea"
                        value={this.state.no_means}
                        onChange={this.handleChange} />
        <Endorsements ref="no_endorsements"
                      className="mui-col-md-5"
                      template={this.props.template}
                      endorsements={this.state.endorsements}
                      handleChange={this.handleChange}
                      endorsed_type='measure'
                      endorsed_id={this.props.id}
                      stance="against" />
      </div>
    </div>
  }
})
