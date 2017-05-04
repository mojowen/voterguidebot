
Rails.application.config.assets.version = '1.0'


Rails.application.config.assets.precompile += %w{
  2016_guide.css guide.css mail.css avg.css avg_img.css
  avg.js avg_embed.js avg_widget.js
  emoji.css emoji.min.js
}
