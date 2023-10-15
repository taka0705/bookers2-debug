class ChatsController < ApplicationController
  before_action :reject_non_related,only:[:show]
  def show
    @user = User.find(params[:id])
    # チャットする相手はだれか
    rooms = current_user.user_rooms.pluck(:room_id)
    # ログイン中のユーザの部屋情報をすべて取得
    user_rooms = UserRoom.find_by(user_id: @user.id,room_id: rooms)
    # その中にチャットするチャットする相手とのルームがあるか確認

  unless user_rooms.nil?
    # ユーザルームがなくなかった(つまりあった)
    @room = user_rooms.room
    # 変数@roomにユーザ(自分と相手)と紐づいてるroomを代入
  else
    # ユーザルームがなかった場合
    @room = Room.new
    # 新しくRoomを作る
    @room.save
    # そして保存
    UserRoom.create(user_id: current_user.id, room_id: @room.id)
    # 自分の中間テーブルを作る
    UserRoom.create(user_id: @user.id,room_id: @room.id)
    # 相手の中間テーブルを作る
  end
  @chats = @room.chats
  # チャットの一覧用の変数
  @chat = Chat.new(room_id: @room.id)
  # チャットの投稿用の変数
end

def create
  @chat = current_user.chats.new(chat_params)
  render :validater unless @chat.save
end



private

def chat_params
  params.require(:chat).permit(:message,:room_id)
end


# ↓現在のユーザが対象のユーザをフォローしていてかつ、対象のユーザが現在のユーザをフォローしていなかった場青、一覧画面へリダイレクトさせるという記述(相互フォローかどうかをみている)
def reject_non_related
  user=User.find(params[:id])
  unless current_user.following?(user) && user.following?(current_user)
    redirect_to books_path
  end
 end
end
