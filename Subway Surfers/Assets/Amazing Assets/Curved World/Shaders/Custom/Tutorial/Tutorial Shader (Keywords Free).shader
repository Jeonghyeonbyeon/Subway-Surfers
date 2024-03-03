Shader "Amazing Assets/Curved World/Tutorial/Unlit Shader (Keywords Free)"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass  
        {
            CGPROGRAM 
            #pragma vertex vert
            #pragma fragment frag 
            #pragma multi_compile_fog
  
            #include "UnityCG.cginc"     
 

			#include "Assets/Amazing Assets/Curved World/Shaders/CGINC/Little Planet/CurvedWorld_LittlePlanet_Y_ID1.cginc"


			sampler2D _MainTex;
            float4 _MainTex_ST;

            struct v2f 
            {
				float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                
            };

            v2f vert (appdata_full v)
            {
                v2f o;


				//Vertex and Normal calcualtion
				CurvedWorld_LittlePlanet_Y_ID1(v.vertex, v.normal, v.tangent);

				//Vertex transformation only
				//CurvedWorld_LittlePlanet_Y_ID1(v.vertex);
					

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
				
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);


                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
