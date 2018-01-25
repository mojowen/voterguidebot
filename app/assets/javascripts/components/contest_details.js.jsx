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
                      label="What This Office Does"
                      placeholder="Responsible for running the city of Gotham - avoiding capture, etc."
                      value={ this.props.description }
                      onChange={ this.handleChange }
                      limit={this.template('contests.description.limit')} />
    </div>
  }
})
