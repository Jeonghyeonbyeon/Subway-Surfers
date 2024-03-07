using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    internal class TerrainShaderGUI : ShaderGUI
    {
        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            CurvedWorldEditor.MaterialProperties.InitCurvedWorldMaterialProperties(properties);
            CurvedWorldEditor.MaterialProperties.DrawCurvedWorldMaterialProperties(materialEditor, MaterialProperties.STYLE.HelpBox, false, false);

            base.OnGUI(materialEditor, properties);
        }
    }
}
