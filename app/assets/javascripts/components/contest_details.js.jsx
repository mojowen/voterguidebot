var ContestDetails = React.createClass({
  getDefaultProps: function() {
    return { title: '',
             description: '',
             handleChange: function() { } }
  },
  render: function() {
    return <div className="contest mui-row">
      <h3>Details</h3>
      <InputComponent name="title"
                      label="title"
                      placeholder="Mayor of Gotham City"
                      ref='title'
                      value={ this.props.title }
                      onChange={ this.props.handleChange } />
      <InputComponent name="description"
                      element="textarea"
                      ref='description'
                      label="Description"
                      placeholder="Responsible for running the city of Gotham - avoiding capture, etc."
                      value={ this.props.description }
                      onChange={ this.props.handleChange } />
    </div>
  }
})
