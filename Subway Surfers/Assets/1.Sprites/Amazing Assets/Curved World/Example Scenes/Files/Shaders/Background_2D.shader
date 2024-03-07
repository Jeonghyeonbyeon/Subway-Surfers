Shader "Custom/Skybox Background 2D" 
{
	Properties 
	{	 
		_Color("  Color", color) = (1, 1, 1, 1)
		[NoScaleOffset] _MainTex ("  Map", 2D) = "white" {}
	}

	SubShader 
	{
		Tags { "QUEUE"="Background" 
			   "RenderType"="Background" 
			 } 
		LOD 200
		Cull Off ZWrite Off

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			fixed4 _Color;
			sampler2D _MainTex;

			struct vertOut 
			{
                float4 pos : SV_POSITION;
                float4 scrPos : TEXCOORD0;
            };

            vertOut vert(appdata_base v) 
			{
                vertOut o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.scrPos = ComputeScreenPos(o.pos);
                
				return o;
            }

            fixed4 frag(vertOut i) : SV_Target 
			{	
                float2 uv = (i.scrPos.xy / i.scrPos.w);

				return tex2D(_MainTex, uv) * _Color;
            }

			ENDCG
		}
	} 
} 
 
