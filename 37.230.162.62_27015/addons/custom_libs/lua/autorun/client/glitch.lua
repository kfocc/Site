-- Credits IVogel

local set_seed, get_seed, get_random_32;

do
  local secret_key_6  = 58;
  local secret_key_7  = 110;
  local secret_key_44 = 3580861008710;

  local floor = math.floor;

  local function primitive_root_257(idx)
    local g, m, d = 1, 128, 2 * idx + 1;
    repeat
      g, m, d = g * g * (d >= m and 3 or 1) % 257, m / 2, d % m;
    until m < 1;
    return g;
  end

  local param_mul_8 = primitive_root_257(secret_key_7);
  local param_mul_45 = secret_key_6 * 4 + 1;
  local param_add_45 = secret_key_44 * 2 + 1;

  local state_45 = 0;
  local state_8 = 2;

  function set_seed(seed_53)
    state_45 = seed_53 % 35184372088832;
    state_8 = floor(seed_53 / 35184372088832) % 255 + 2;
  end

  function get_seed()
    return (state_8 - 2) * 35184372088832 + state_45;
  end

  function get_random_32()
    state_45 = (state_45 * param_mul_45 + param_add_45) % 35184372088832;
    repeat
      state_8 = state_8 * param_mul_8 % 257;
    until state_8 ~= 1;
    local r = state_8 % 32;
    local n = floor(state_45 / 2^(13 - (state_8 - r) / 32)) % 2^32 / 2^r;
    return floor(n % 1 * 2^32) + floor(n);
  end
end

local EFFECT_TEXTURE_MAT = CreateMaterial("glitch_effect_material1337", "UnlitGeneric", {
  ["$basetexture"] = "_rt_fullframefb",
  ["$vertexcolor"] = 1,
  ["$additive"]    = 1
})

local OFFSET = 20

local scisx, scisy
local scisw, scish
local scrw, scrh
local scale
local max, min = math.max, math.min
local function draw_glitch_pass(seed, offset_seed, element_count)
  render.UpdateScreenEffectTexture();
  surface.SetMaterial(EFFECT_TEXTURE_MAT)
  local last_seed = seed
  local last_seed2 = offset_seed
  local minu, maxu = scisx/scrw, (scisx + scisw)/scrw
  local minv, maxv = scisy/scrh, (scisy + scish)/scrh
  for _ = 1, element_count do
    set_seed(last_seed);
    local element_width   = ((get_random_32() % 64) + 128) * scale;
    local element_height  = ((get_random_32() % 8) + 16) * scale;
    local element_x       = get_random_32() % (scrw + element_width * 2) - element_width;
    local element_y       = get_random_32() % (scrh + element_height * 2) - element_height;
    local random_offset_x = (get_random_32() % 32) - 16;
    local random_offset_y = (get_random_32() % 32) - 16;

    last_seed = get_seed();
    set_seed(last_seed2);
    local r = get_random_32() % 20;
    surface.SetDrawColor(r, r, r)
    surface.DrawRect(
      element_x + random_offset_x,
      element_y + random_offset_y,
      element_width,
      element_height
    );
    surface.SetDrawColor(255, 0, 0);
    surface.DrawTexturedRectUV(
      element_x + random_offset_x,
      element_y + random_offset_y,
      element_width,
      element_height,
      max((element_x - ((get_random_32() % OFFSET) - OFFSET / 2)) / scrw, minu),
      max((element_y - ((get_random_32() % OFFSET) - OFFSET / 2)) / scrh, minv),
      min((element_x + element_width - ((get_random_32() % OFFSET) - OFFSET / 2)) / scrw, maxu),
      min((element_y + element_height - ((get_random_32() % OFFSET) - OFFSET / 2)) / scrh, maxv)
    );
    surface.SetDrawColor(0, 255, 0);
    surface.DrawTexturedRectUV(
      element_x + random_offset_x,
      element_y + random_offset_y,
      element_width,
      element_height,
      max(element_x / scrw, minu),
      max(element_y / scrh, minv),
      min((element_x + element_width) / scrw, maxu),
      min((element_y + element_height) / scrh, maxv)
    );
    surface.SetDrawColor(0, 0, 255);
    surface.DrawTexturedRectUV(
      element_x + random_offset_x,
      element_y + random_offset_y,
      element_width,
      element_height,
      max((element_x + ((get_random_32() % OFFSET) - OFFSET / 2)) / scrw, minu),
      max((element_y + ((get_random_32() % OFFSET) - OFFSET / 2)) / scrh, minv),
      min((element_x + element_width + ((get_random_32() % OFFSET) - OFFSET / 2)) / scrw, maxu),
      min((element_y + element_height + ((get_random_32() % OFFSET) - OFFSET / 2)) / scrh, maxv)
    );
    last_seed2 = get_seed();
  end
end

local next_update = 0
local next_update2 = 0
local SEED_1 = math.random(0, 0x123456789ABCDE);
local SEED_2 = math.random(0, 0x123456789ABCDE);
local SEED_3 = math.random(0, 0x123456789ABCDE);
local SEED_4 = math.random(0, 0x123456789ABCDE);

function renderGlith(x, y, w, h, c1, c2, s)
  scisx, scisy = x, y
  scisw, scish = w, h
  scrw, scrh = ScrW(), ScrH()
  scale = s
  set_seed(SEED_1);
  local time = SysTime();
  local seed1 = get_random_32();
  local seed2 = get_random_32();
  draw_glitch_pass(seed1, SEED_3, c1);
  draw_glitch_pass(seed2, SEED_4, c2);
  -- draw_glitch_pass(seed3, SEED_4, 64);
  -- draw_glitch_pass(seed4, SEED_4, 64);
  if next_update < time then
  	 next_update = time + math.random();
  	 SEED_1 = math.random(0, 0x123456789ABCDE);
  	 SEED_2 = math.random(0, 0x123456789ABCDE);
  end
  if next_update2 < time then
    next_update2 = time + 0.0333;
    SEED_3 = math.random(0, 0x123456789ABCDE);
    SEED_4 = math.random(0, 0x123456789ABCDE);
  end
end
/*local renderGlith = renderGlith
hook.Add("PostRenderVGUI", "geffect", function()
  local time = SysTime();
  renderGlith(0, 0, ScrW(), ScrH(), 128, 64, 1)
  print(SysTime() - time)
end);*/