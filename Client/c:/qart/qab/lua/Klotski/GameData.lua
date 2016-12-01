
GameData = {}

function GameData.GetHeroInfoById(id)

	for k, v in pairs(GameData.HeroInfo) do
		if (id == v.id) then
			return v
		end
	end

	return nil

end

GameData.HeroSize = {
	{id=3, width=2, height=2}, -- 1

	{id=9, width=2, height=1}, -- 2

	{id=7, width=2, height=1}, -- 3

	{id=2, width=2, height=1}, -- 4

	{id=5, width=2, height=1}, -- 5

	{id=11, width=2, height=1}, -- 6

	{id=1, width=1, height=2}, -- 7

	{id=4, width=1, height=2}, -- 8

	{id=6, width=1, height=2}, -- 9

	{id=8, width=1, height=2}, -- 10

	{id=10, width=1, height=2}, -- 11

	{id=12, width=1, height=1} -- 12
}

function GameData.GetHeroSizeById(id)

	for k, v in pairs(GameData.HeroSize) do
		if (id == v.id) then
			return v
		end
	end

	return nil

end

GameData.HeroInfo = {
	{id=1, name="张飞竖", icon="zhangfei_s", main=0}, --1

	{id=2, name="张飞", icon="zhangfei_h", main=0}, --2

	{id=3, name="曹操", icon="caocao", main=1}, --3

	{id=4, name="赵云竖", icon="zhaoyun_s", main=0}, --4

	{id=5, name="赵云", icon="zhaoyun_h", main=0}, --5

	{id=6, name="马超竖", icon="machao_s", main=0}, --6

	{id=7, name="马超", icon="machao_h", main=0}, --7

	{id=8, name="关羽竖", icon="guanyu_s", main=0}, --8

	{id=9, name="关羽", icon="guanyu", main=0}, --9

	{id=10, name="黄忠竖", icon="huangzhong_s", main=0}, --10

	{id=11, name="黄忠", icon="huangzhong_h", main=0}, --11

	{id=12, name="士兵", icon="bing", main=0}, --12
}

GameData.LevelsData = {
	{title="羊肠小道", level=1001, data={{id =1, hero=1, x=0.5, y=1}, {id=2, hero=4, x=1.5, y=1}, {id=3, hero=8, x=3.5, y=1}, 
		{id=4, hero=12, x=0.5, y=2.5}, {id=5, hero=12, x=0.5, y=3.5}, {id=6, hero=3, x=2, y=3}, {id=7, hero=12, x=3.5, y=2.5}, 
		{id=8, hero=12, x=3.5, y=3.5}, {id=9, hero=7, x=1, y=4.5}, {id=10, hero=11, x=3, y=4.5}}},--1

	{title="逃之夭夭", level=1002, data={{id =1, hero=1, x=0.5, y=1}, {id=2, hero=12, x=1.5, y=1.5}, {id=3, hero=12, x=2.5, y=1.5}, 
		{id=4, hero=8, x=3.5, y=1}, {id=5, hero=6, x=0.5, y=3}, {id=6, hero=3, x=2, y=3}, 
		{id=7, hero=10, x=3.5, y=3}, {id=8, hero=12, x=0.5, y=4.5}, {id=9, hero=5, x=2, y=4.5}, {id=10, hero=12, x=3.5, y=4.5}}},--2

	{title="壁垒森严", level=1003, data={
	    {id =1, hero=11, x=2, y=0.5}, {id=2, hero=12, x=0.5, y=1.5}, {id=3, hero=12, x=1.5, y=1.5}, 
		{id=4, hero=12, x=2.5, y=1.5}, {id=5, hero=12, x=0.5, y=2.5}, {id=6, hero=3, x=2, y=3}, {id=7, hero=12, x=0.5, y=3.5}, 
		{id=8, hero=12, x=3.5, y=2.5}, {id=9, hero=12, x=3.5, y=3.5}, {id=10, hero=12, x=0.5, y=4.5}, {id=11, hero=12, x=1.5, y=4.5}, 
		{id=12, hero=12, x=2.5, y=4.5}, {id=13, hero=12, x=3.5, y=4.5}, {id=14, hero=12, x=3.5, y=1.5}}},--3

	{title="一字长蛇", level=1004, data={{id =1, hero=12, x=0.5, y=0.5}, {id=2, hero=12, x=1.5, y=0.5}, {id=3, hero=12, x=2.5, y=0.5}, 
		{id=4, hero=12, x=3.5, y=0.5}, {id=5, hero=12, x=0.5, y=1.5}, {id=6, hero=12, x=1.5, y=1.5}, {id=7, hero=12, x=2.5, y=1.5}, 
		{id=8, hero=12, x=3.5, y=1.5}, {id=9, hero=2, x=1, y=2.5},  {id=10, hero=5, x=3, y=2.5}, {id=11, hero=9, x=1, y=3.5}, {id=12, hero=3, x=3, y=4}}},--4

	{title="网开一面", level=1005, data={{id=1, hero=8, x=0.5, y=1}, {id=2, hero=12, x=1.5, y=1.5}, {id=3, hero=12, x=2.5, y=1.5}, 
		{id=4, hero=1, x=3.5, y=1}, {id=5, hero=12, x=0.5, y=2.5}, {id=6, hero=12, x=1.5, y=2.5}, {id=7, hero=12, x=2.5, y=2.5}, 
		{id=8, hero=12, x=3.5, y=2.5}, {id=9, hero=12, x=0.5, y=3.5}, {id=10, hero=12, x=0.5, y=4.5}, 
		{id=11, hero=3, x=2, y=4}, {id=12, hero=12, x=3.5, y=3.5}, {id=13, hero=12, x=3.5, y=4.5}}},--5


	{title="四面楚歌", level=1006, data={{id=1, hero=6, x=0.5, y=1}, {id=2, hero=12, x=1.5, y=0.5}, {id=3, hero=12, x=2.5, y=0.5}, 
		{id=4, hero=12, x=1.5, y=1.5}, {id=5, hero=12, x=2.5, y=1.5}, {id=6, hero=10, x=3.5, y=1}, {id=7, hero=1, x=0.5, y=3}, 
		{id=8, hero=12, x=0.5, y=4.5}, {id=9, hero=3, x=2, y=4}, {id=10, hero=4, x=3.5, y=3}, {id=11, hero=12, x=3.5, y=4.5}}},--6


	{title="天罗地网", level=1007, data={{id=1, hero=12, x=0.5, y=0.5}, {id=2, hero=12, x=1.5, y=0.5}, {id=3, hero=9, x=3, y=0.5}, 
		{id=4, hero=12, x=0.5, y=1.5}, {id=5, hero=12, x=1.5, y=1.5}, {id=6, hero=3, x=3, y=2}, 
		{id=7, hero=12, x=0.5, y=2.5}, {id=8, hero=12, x=1.5, y=2.5}, {id=9, hero=12, x=0.5, y=3.5}, 
		{id=10, hero=12, x=0.5, y=4.5}, {id=11, hero=12, x=2.5, y=3.5}, {id=12, hero=12, x=3.5, y=3.5}, 
		{id=13, hero=12, x=2.5, y=4.5}, {id=14, hero=12, x=3.5, y=4.5} }},--7


	{title="横刀立马", level=1008, data={{id=1, hero=11, x=1, y=0.5}, {id=2, hero=12, x=2.5, y=0.5}, {id=3, hero=12, x=3.5, y=0.5}, 
		{id=4, hero=5, x=1, y=1.5}, {id=5, hero=7, x=3, y=1.5}, {id=6, hero=9, x=1, y=2.5}, 
		{id=7, hero=2, x=3, y=2.5}, {id=8, hero=12, x=0.5, y=3.5}, {id=9, hero=12, x=0.5, y=4.5}, {id=10, hero=3, x=2, y=4}}},--8


	{title="尽在咫尺", level=1009, data={{id =1, hero=12, x=0.5, y=0.5}, {id=2, hero=6, x=1.5, y=1}, {id=3, hero=8, x=2.5, y=1}, 
		{id=4, hero=12, x=0.5, y=2.5}, {id=5, hero=12, x=0.5, y=3.5}, {id=6, hero=3, x=2, y=3}, {id=7, hero=12, x=3.5, y=2.5},
		 {id=8, hero=12, x=3.5, y=3.5}, {id=9, hero=12, x=0.5, y=4.5}, {id=10, hero=12, x=3.5, y=4.5},
		  {id=11, hero=12, x=0.5, y=1.5}, {id=12, hero=12, x=3.5, y=0.5}, {id=13, hero=12, x=3.5, y=1.5}}},--9

	{title="铜墙铁壁", level=10010, data={{id=1, hero=12, x=0.5, y=0.5}, {id=2, hero=12, x=0.5, y=1.5}, {id=3, hero=11, x=2, y=1.5}, 
		{id=4, hero=12, x=3.5, y=0.5}, {id=5, hero=12, x=3.5, y=1.5}, {id=6, hero=12, x=0.5, y=2.5}, {id=7, hero=12, x=1.5, y=2.5}, 
		{id=8, hero=12, x=2.5, y=2.5}, {id=9, hero=12, x=3.5, y=2.5}, {id=10, hero=4, x=0.5, y=4}, {id=11, hero=3, x=2, y=4},{id=12, hero=6, x=3.5, y=4}}},--10
}

return GameData