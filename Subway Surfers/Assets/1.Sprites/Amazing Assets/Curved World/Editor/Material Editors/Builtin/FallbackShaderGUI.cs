using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    internal class FallbackShaderGUI : ShaderGUI
    {
        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            CurvedWorldEditor.MaterialProperties.InitCurvedWorldMaterialProperties(properties);
            CurvedWorldEditor.MaterialProperties.DrawCurvedWorldMaterialProperties(materialEditor, MaterialProperties.STYLE.HelpBox, true, true);

            base.OnGUI(materialEditor, properties);
        }
    }
}