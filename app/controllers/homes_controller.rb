class HomesController < ApplicationController
  #raise params.inspect

  def index
    @user = User.find(current_user.id) if current_user
    @meme = Meme.new
    @tag = Tag.new
    
    
    if params[:filter]
      case params[:filter]
      when "best_today"
        @memes = []
        sort_memes_by_likes(Meme.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day))
          .each {|item| @memes.push(item["meme"])}
      when "best_week"
        @memes = []
        sort_memes_by_likes(Meme.where(created_at: Date.today - 7..Date.today.end_of_day))
          .each {|item| @memes.push(item["meme"])}
      when "best_month"
        @memes = []
        sort_memes_by_likes(Meme.where(created_at: Date.today - 30..Date.today.end_of_day))
          .each {|item| @memes.push(item["meme"])}
      when "best_all_time"
        @memes = []
        sort_memes_by_likes(Meme.all).each {|item| @memes.push(item["meme"])}
      end
    elsif params[:tag]
      @memes = Tag.where(name: params[:tag])[0].memes
    else
      @memes = Meme.all.order(created_at: :desc)
    end
    @memes = pagination(@memes)
  end

  private
  def sort_memes_by_likes(array)
    to_sort = []
    array.each do |m|
      new_obj = {}
      new_obj.store('meme', m)
      new_obj.store('likes', m.likes.count)
      to_sort.push(new_obj)
    end
    to_sort.sort_by! {|item| item['likes']}.reverse
  end

  def pagination(array)
    @page = params[:page] || 1
    @limit = params[:limit] || 2
    @page = @page.to_i
    @limit = @limit.to_f
    @max_page = (array.count.to_f / @limit).ceil
    #, max_page: max_page
    #return {page: :page, limit: :limit}#,
    return array[(@page -1) * @limit, @limit]
   # .offset((page - 1) * limit).limit(limit)
  end

end