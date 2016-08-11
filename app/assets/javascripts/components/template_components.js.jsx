var ColorBlob = React.createClass({
  getDefaultProps: function() {
    return { color: 'transparent' }
  },
  render: function() {
    var style = {
      backgroundColor: this.props.color,
      border: '10px rgba(255, 255, 255, 0.5) solid',
      width: '100%',
      height: '100px',
      color: 'white',
      padding: '10px'
    }
    return <div style={style}>
      <h2 style={{ color: 'white', margin: 0, padding: 0 }}>HERE IS THE BACK OF YOUR GUIDE</h2>
      <p style={{ color: 'white' }}>This is what the back page of your guide will look like.</p>
    </div>
  }
})

var ColorText = React.createClass({
  getDefaultProps: function() {
    return { color: 'transparent' }
  },
  render: function() {
    return <div>
      <div className="name">
        <h3 style={{ color: this.props.color }} >Candidate Name</h3>
        <span className="party">Independent</span>
      </div>
      <div className="photo"><div className="img unknown"></div></div>
    </div>
  }
})

var ContestType = React.createClass({
  getDefaultProps: function() {
    return { partial: 'contest_large' }
  },
  render: function() {
    var copy = {
      contest_large: 'Four candididates and six questions on two pages per contest',
      contest_small: 'Three candididates and three questions on one pages per contest',
    }
    return <div className="contest--type">
      <div className={this.props.partial + ' thumbnail'} />
      <p>{ copy[this.props.partial] }</p>
    </div>
  }
})
