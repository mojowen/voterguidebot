var ContestDetails = React.createClass({
  mixins: [Template],
  getDefaultProps: function() {
    return { title: '',
             description: '',
             handleChange: function() { } }
  },
  handleChange: function(event) {
    this.props.handleChange(event.target.name, event.target.value)
  },
  render: function() {
    var desc = "Description",
        desc_limit_key = 'description'
    if(  this.props.contest_layout === 'contest_small' ) {
      desc = "What This Office Does In 15 Words"
      desc_limit_key = 'description_15_words'
    }
    return <div className="contest mui-row">
      <h3>Details</h3>
      <InputComponent name="title"
                      label="title"
                      placeholder="Mayor of Gotham City"
                      ref='title'
                      value={ this.props.title }
                      onChange={ this.handleChange }
                      limit={this.template('contests.title.limit')} />
      <InputComponent name="description"
                      element="textarea"
                      ref='description'
                      label={desc}
                      placeholder="Responsible for running the city of Gotham - avoiding capture, etc."
                      value={ this.props.description }
                      onChange={ this.handleChange }
                      limit={this.template('contests.' + desc_limit_key +'.limit')} />
    </div>
  }
})
